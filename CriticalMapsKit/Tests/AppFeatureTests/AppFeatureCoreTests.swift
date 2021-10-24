@testable import AppFeature
import Combine
import ComposableArchitecture
import ComposableCoreLocation
import Foundation
import MapFeature
import NextRideFeature
import SharedModels
import UserDefaultsClient
import XCTest

class AppFeatureTests: XCTestCase {
  let testScheduler = DispatchQueue.test
  
  func test_onAppearAction_shouldSendEffectTimerStart_andMapOnAppear() {
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    let setSubject = PassthroughSubject<Never, Never>()
    
    var environment = AppEnvironment(
      service: .noop,
      idProvider: .noop,
      mainQueue: DispatchQueue.immediate.eraseToAnyScheduler(),
      locationManager: .unimplemented(
        authorizationStatus: { .denied },
        create: { _ in locationManagerSubject.eraseToEffect() },
        locationServicesEnabled: { true },
        set: { (_, _) -> Effect<Never, Never> in setSubject.eraseToEffect() }
      ),
      userDefaultsClient: .noop,
      uiApplicationClient: .noop,
      fileClient: .noop,
      setUserInterfaceStyle: { _ in .none }
    )
    environment.fileClient.load = { asdf in
        .init(
          value: try! JSONEncoder().encode(
            UserSettings()
          )
        )
    }
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    )
    
    store.assert(
      .send(.onAppear),
      .receive(.userSettingsLoaded(.success(.init()))),
      .receive(.map(.onAppear)),
      .receive(.requestTimer(.startTimer)),
      .receive(.map(.locationRequested)) {
        $0.mapFeatureState.alert = .goToSettingsAlert
      },
      .send(.requestTimer(.stopTimer)),
      .do {
        setSubject.send(completion: .finished)
        locationManagerSubject.send(completion: .finished)
      }
    )
  }
  
  func test_onAppearWithEnabledLocationServices_shouldSendUserLocation_afterLocationUpated() {
    let setSubject = PassthroughSubject<Never, Never>()
    var didRequestAlwaysAuthorization = false
    var didRequestLocation = false
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    let serviceSubject = PassthroughSubject<LocationAndChatMessages, NSError>()
    let nextRideSubject = PassthroughSubject<[Ride], NextRideService.Failure>()
    
    let currentLocation = Location(
      altitude: 0,
      coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 10),
      course: 0,
      horizontalAccuracy: 0,
      speed: 0,
      timestamp: Date(timeIntervalSince1970: 1_234_567_890),
      verticalAccuracy: 0
    )
    var service: LocationsAndChatDataService = .noop
    service.getLocations = { _ in
      serviceSubject.eraseToAnyPublisher()
    }
    var nextRideService: NextRideService = .noop
    nextRideService.nextRide = { _, _ in
      nextRideSubject.eraseToAnyPublisher()
    }
    var settings = UserDefaultsClient.noop
    settings.dataForKey = { _ in
      try? RideEventSettings(
        isEnabled: true,
        typeSettings: [],
        radiusSettings: 10
      )
      .encoded()
    }
    var environment = AppEnvironment(
      service: service,
      idProvider: .noop,
      mainQueue: testScheduler.eraseToAnyScheduler(),
      locationManager: .unimplemented(
        authorizationStatus: { .notDetermined },
        create: { _ in locationManagerSubject.eraseToEffect() },
        locationServicesEnabled: { true },
        requestAlwaysAuthorization: { _ in
          .fireAndForget { didRequestAlwaysAuthorization = true }
        },
        requestLocation: { _ in .fireAndForget { didRequestLocation = true } },
        set: { (_, _) -> Effect<Never, Never> in setSubject.eraseToEffect() }
      ),
      nextRideService: nextRideService,
      userDefaultsClient: settings,
      uiApplicationClient: .noop,
      fileClient: .noop,
      setUserInterfaceStyle: { _ in .none }
    )
    environment.fileClient.load = { asdf in
        .init(
          value: try! JSONEncoder().encode(
            UserSettings()
          )
        )
    }
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    )
    
    let coordinate = Coordinate(latitude: 20, longitude: 10)
    let serviceResponse = LocationAndChatMessages(
      locations: ["ID": .init(coordinate: coordinate, timestamp: 00)],
      chatMessages: ["ID": ChatMessage(message: "Hello World!", timestamp: 0)]
    )
    
    store.assert(
      .send(.onAppear),
      .receive(.userSettingsLoaded(.success(.init()))),
      .receive(.map(.onAppear)),
      .receive(.requestTimer(.startTimer)),
      .receive(.map(.locationRequested)) {
        $0.mapFeatureState.isRequestingCurrentLocation = true
      },
      .do {
        locationManagerSubject.send(.didChangeAuthorization(.authorizedAlways))
      },
      .receive(.map(.locationManager(.didChangeAuthorization(.authorizedAlways)))),
      .do { XCTAssertTrue(didRequestLocation) },
      .do {
        locationManagerSubject.send(.didUpdateLocations([currentLocation]))
      },
      .receive(.map(.locationManager(.didUpdateLocations([currentLocation])))) {
        $0.mapFeatureState.isRequestingCurrentLocation = false
        $0.mapFeatureState.location = currentLocation
        $0.didResolveInitialLocation = true
      },
      .receive(.fetchData),
      .receive(.nextRide(.getNextRide(coordinate))),
      .do {
        serviceSubject.send(serviceResponse)
        nextRideSubject.send([])
        self.testScheduler.advance()
      },
      .receive(.fetchDataResponse(.success(serviceResponse))) {
        $0.locationsAndChatMessages = .success(serviceResponse)
        $0.mapFeatureState.riders = serviceResponse.riders
      },
      .receive(.nextRide(.nextRideResponse(.success([])))),
      .do { self.testScheduler.advance(by: 12) },
      .receive(.requestTimer(.timerTicked)),
      .receive(.fetchData),
      .do {
        serviceSubject.send(completion: .failure(NSError(domain: "", code: 0, userInfo: [:])))
        self.testScheduler.advance()
      },
      .receive(.fetchDataResponse(.failure(NSError(domain: "", code: 0, userInfo: [:])))) {
        $0.locationsAndChatMessages = .failure(.init())
      },
      .receive(.fetchDataResponse(.failure(NSError(domain: "", code: 0, userInfo: [:])))),
               
      .send(.requestTimer(.stopTimer)),
      .do {
        setSubject.send(completion: .finished)
        locationManagerSubject.send(completion: .finished)
        serviceSubject.send(completion: .finished)
        nextRideSubject.send(completion: .finished)
        self.testScheduler.advance()
      }
    )
  }
  
  func test_appNavigation() {
    let store = TestStore(
      initialState: AppState(
        locationsAndChatMessages: nil
      ),
      reducer: appReducer,
      environment: AppEnvironment(
        uiApplicationClient: .noop,
        setUserInterfaceStyle: { _ in .none })
    )
    
    store.assert(
      .send(.setNavigation(tag: .chat)) {
        $0.route = .chat
        XCTAssertTrue($0.isChatViewPresented)
      },
      .send(.dismissSheetView) {
        $0.route = .none
      },
      .send(.setNavigation(tag: .rules)) {
        $0.route = .rules
        XCTAssertTrue($0.isRulesViewPresented)
      },
      .send(.dismissSheetView) {
        $0.route = .none
      },
      .send(.setNavigation(tag: .settings)) {
        $0.route = .settings
        XCTAssertTrue($0.isSettingsViewPresented)
      },
      .send(.dismissSheetView) {
        $0.route = .none
      }
    )
  }
}
