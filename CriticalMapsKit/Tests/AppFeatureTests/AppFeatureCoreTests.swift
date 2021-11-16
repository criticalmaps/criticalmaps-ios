@testable import AppFeature
import ApiClient
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
    service.getLocationsAndSendMessages = { _ in
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
    
    var appState = AppState()
    appState.chatMessageBadgeCount = 3
    
    let store = TestStore(
      initialState: appState,
      reducer: appReducer,
      environment: environment
    )
    
    let nextRideCoordinate: Coordinate = .make()
    let serviceResponse: LocationAndChatMessages = .make()
    
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
      .do {
        XCTAssertTrue(didRequestLocation)
        locationManagerSubject.send(.didUpdateLocations([currentLocation]))
      },
      .receive(.map(.locationManager(.didUpdateLocations([currentLocation])))) {
        $0.mapFeatureState.isRequestingCurrentLocation = false
        $0.mapFeatureState.location = currentLocation
        $0.didResolveInitialLocation = true
      },
      .receive(.fetchData),
      .receive(.nextRide(.getNextRide(.init(latitude: 20, longitude: 10)))),
      .do {
        serviceSubject.send(serviceResponse)
        nextRideSubject.send([])
        self.testScheduler.advance()
      },
      .receive(.fetchDataResponse(.success(serviceResponse))) {
        $0.locationsAndChatMessages = .success(serviceResponse)
        $0.socialState = .init(
          chatFeautureState: .init(chatMessages: serviceResponse.chatMessages),
          twitterFeedState: .init()
        )
        $0.mapFeatureState.riders = serviceResponse.riders
        $0.chatMessageBadgeCount = 6
      },
      .receive(.nextRide(.nextRideResponse(.success([])))),
      .do { self.testScheduler.advance(by: 12) },
      .receive(.requestTimer(.timerTicked)),
      .receive(.fetchData),
      .do {
        serviceSubject.send(completion: .failure(testError))
        self.testScheduler.advance()
      },
      .receive(.fetchDataResponse(.failure(testError))) {
        $0.locationsAndChatMessages = .failure(testError)
      },
      .receive(.fetchDataResponse(.failure(testError))),
               
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
      initialState: AppState(),
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
  
  func test_resetUnreadMessagesCount_whenAction_chat_onAppear() {
    var appState = AppState()
    appState.chatMessageBadgeCount = 13
    
    let store = TestStore(
      initialState: appState,
      reducer: appReducer,
      environment: AppEnvironment(
        uiApplicationClient: .noop,
        setUserInterfaceStyle: { _ in .none })
    )
    
    store.assert(
      .send(.social(.chat(.onAppear))) { state in
        state.chatMessageBadgeCount = 0
      }
    )
  }
  
  func test_unreadChatMessagesCount() {
    let date: () -> Date = { Date(timeIntervalSinceReferenceDate: 0) }
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        uiApplicationClient: .noop,
        setUserInterfaceStyle: { _ in .none })
    )
    
    let response: LocationAndChatMessages = .make(12)
    let response2: LocationAndChatMessages = .init(
      locations: [:],
      chatMessages: [
        "NEWID": ChatMessage(message: "Hi", timestamp: date().timeIntervalSince1970 + 15)
      ]
    )
    let response3: LocationAndChatMessages = .init(
      locations: [:],
      chatMessages: [
        "NEWID": ChatMessage(message: "Hi", timestamp: date().timeIntervalSince1970 + 15),
        "NEWID3": ChatMessage(message: "Hi", timestamp: date().timeIntervalSince1970 + 16),
        "NEWID2": ChatMessage(message: "Hi", timestamp: date().timeIntervalSince1970 + 17)
      ]
    )
    let response4: LocationAndChatMessages = .init(
      locations: [:],
      chatMessages: [
        "NEWID": ChatMessage(message: "Hi", timestamp: date().timeIntervalSince1970 + 15),
        "NEWID3": ChatMessage(message: "Hi", timestamp: date().timeIntervalSince1970 + 16),
        "NEWID2": ChatMessage(message: "Hi", timestamp: date().timeIntervalSince1970 + 17),
        "NEWID5": ChatMessage(message: "Hi", timestamp: date().timeIntervalSince1970 + 18)
      ]
    )
    
    store.assert(
      .environment { env in
        env.userDefaultsClient.doubleForKey = { _ in
          date().timeIntervalSince1970
        }
      },
      .send(.fetchDataResponse(.success(response))) { state in
        state.locationsAndChatMessages = .success(response)
        state.socialState.chatFeautureState.chatMessages = response.chatMessages
        state.mapFeatureState.riders = response.riders
        
        state.chatMessageBadgeCount = 6
      },
      .environment { env in
        env.userDefaultsClient.doubleForKey = { _ in
          date().timeIntervalSince1970 + 14
        }
      },
      .send(.fetchDataResponse(.success(response2))) { state in
        state.locationsAndChatMessages = .success(response2)
        state.socialState.chatFeautureState.chatMessages = response2.chatMessages
        state.mapFeatureState.riders = response2.riders
        
        state.chatMessageBadgeCount = 1
      },
      .send(.fetchDataResponse(.success(response3))) { state in
        state.locationsAndChatMessages = .success(response3)
        state.socialState.chatFeautureState.chatMessages = response3.chatMessages
        state.mapFeatureState.riders = response3.riders
        
        state.chatMessageBadgeCount = 3
      },
      .send(.setNavigation(tag: .chat)) { state in
        state.route = .chat
        XCTAssertTrue(state.isChatViewPresented)
      },
      .send(.social(.chat(.onAppear))) { state in
        state.chatMessageBadgeCount = 0
      },
      .send(.fetchDataResponse(.success(response4))) { state in
        state.locationsAndChatMessages = .success(response4)
        state.socialState.chatFeautureState.chatMessages = response4.chatMessages
        state.mapFeatureState.riders = response4.riders
        
        state.chatMessageBadgeCount = 0
      }
    )
  }
}


// MARK: Helper
let testError = NSError(domain: "", code: 1, userInfo: [:])

extension Coordinate {
  static func make() -> Self {
    let randomDouble: () -> Double = { Double.random(in: 0.0...80.00) }
    return Coordinate(latitude: randomDouble(), longitude: randomDouble())
  }
}

let testDate: () -> Date = { Date(timeIntervalSinceReferenceDate: 0) }

extension Dictionary where Key == String, Value == SharedModels.Location {
  static func make(_ max: Int = 5) -> [Key: Value] {
    let locations = Array(0...max).map { index in
      SharedModels.Location(
        coordinate: .make(),
        timestamp: testDate().timeIntervalSince1970 + Double((index % 2 == 0 ? index : -index))
      )
    }
    var locationDict: [String: SharedModels.Location] = [:]
    for index in locations.indices {
      locationDict[String(index)] = locations[index]
    }
    return locationDict
  }
}

extension Dictionary where Key == String, Value == ChatMessage {
  static func make(_ max: Int = 5) -> [Key: Value] {
    let messages = Array(0...max).map { index in
      ChatMessage(
        message: "Hello World!",
        timestamp: testDate().timeIntervalSince1970 + Double((index % 2 == 0 ? index : -index))
      )
    }
    var messagesDict: [String: ChatMessage] = [:]
    for index in messages.indices {
      messagesDict[String(index)] = messages[index]
    }
    return messagesDict
  }
}

extension LocationAndChatMessages {
  static func make(_ max: Int = 5) -> Self {
    LocationAndChatMessages(
      locations: .make(max),
      chatMessages: .make(max)
    )
  }
}
