import ApiClient
@testable import AppFeature
import Combine
import CombineSchedulers
import ComposableArchitecture
import ComposableCoreLocation
import Foundation
import MapFeature
import NextRideFeature
import PathMonitorClient
import SharedModels
import UserDefaultsClient
import XCTest

// swiftlint:disable:next type_body_length
class AppFeatureTests: XCTestCase {
  let testScheduler = DispatchQueue.test
  
  func test_onAppearAction_shouldSendEffectTimerStart_andMapOnAppear() {
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    let setSubject = PassthroughSubject<Never, Never>()
    let serviceSubject = PassthroughSubject<LocationAndChatMessages, NSError>()
    
    var service: LocationsAndChatDataService = .noop
    service.getLocationsAndSendMessages = { _ in
      serviceSubject.eraseToAnyPublisher()
    }
    
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationManagerSubject.eraseToEffect() }
    locationManager.authorizationStatus = { .denied }
    locationManager.locationServicesEnabled = { true }
    locationManager.set = { _ in setSubject.eraseToEffect() }
    
    var environment = AppEnvironment(
      service: service,
      idProvider: .noop,
      mainQueue: DispatchQueue.immediate.eraseToAnyScheduler(),
      locationManager: locationManager,
      userDefaultsClient: .noop,
      uiApplicationClient: .noop,
      fileClient: .noop,
      setUserInterfaceStyle: { _ in .none },
      pathMonitorClient: .satisfied
    )
    environment.fileClient.load = { _ in
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
    
    
    store.send(.onAppear)
    store.receive(.observeConnection)
    store.receive(.userSettingsLoaded(.success(.init())))
    store.receive(.map(.onAppear))
    store.receive(.requestTimer(.startTimer))
    store.receive(.observeConnectionResponse(NetworkPath(status: .satisfied))) {
      $0.hasConnectivity = true
    }
    store.receive(.map(.locationRequested)) {
      $0.mapFeatureState.alert = .goToSettingsAlert
    }
    store.receive(.requestTimer(.timerTicked))
    store.receive(.fetchData)
  
    serviceSubject.send(completion: .failure(testError))
    testScheduler.advance()
    
    store.receive(.fetchDataResponse(.failure(testError))) {
      $0.locationsAndChatMessages = .failure(testError)
    }
    
    store.send(.requestTimer(.stopTimer))
    
    setSubject.send(completion: .finished)
    serviceSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
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
    nextRideService.nextRide = { _, _, _ in
      nextRideSubject.eraseToAnyPublisher()
    }
    var settings = UserDefaultsClient.noop
    settings.dataForKey = { _ in
      try? RideEventSettings(
        isEnabled: true,
        typeSettings: [],
        eventDistance: .near
      )
      .encoded()
    }
    
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationManagerSubject.eraseToEffect() }
    locationManager.authorizationStatus = { .notDetermined }
    locationManager.locationServicesEnabled = { true }
    locationManager.requestAlwaysAuthorization = { .fireAndForget {
        didRequestAlwaysAuthorization = true
    } }
    locationManager.requestLocation = { .fireAndForget { didRequestLocation = true } }
    locationManager.set = { _ in setSubject.eraseToEffect() }
    
    var environment = AppEnvironment(
      service: service,
      idProvider: .noop,
      mainQueue: testScheduler.eraseToAnyScheduler(),
      locationManager: locationManager,
      nextRideService: nextRideService,
      userDefaultsClient: settings,
      uiApplicationClient: .noop,
      fileClient: .noop,
      setUserInterfaceStyle: { _ in .none },
      pathMonitorClient: .satisfied
    )
    environment.fileClient.load = { _ in
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
    
    let serviceResponse: LocationAndChatMessages = .make()
    
    store.send(.onAppear)
    store.receive(.observeConnection)
    store.receive(.userSettingsLoaded(.success(.init())))
    store.receive(.map(.onAppear))
    store.receive(.requestTimer(.startTimer))
    store.receive(.map(.locationRequested)) {
      $0.mapFeatureState.isRequestingCurrentLocation = true
    }
    
    locationManagerSubject.send(.didChangeAuthorization(.authorizedAlways))
    
    store.receive(.map(.locationManager(.didChangeAuthorization(.authorizedAlways))))
    
    XCTAssertTrue(didRequestLocation)
    locationManagerSubject.send(.didUpdateLocations([currentLocation]))
    
    store.receive(.map(.locationManager(.didUpdateLocations([currentLocation])))) {
      $0.mapFeatureState.isRequestingCurrentLocation = false
      $0.mapFeatureState.location = currentLocation
      $0.didResolveInitialLocation = true
    }
    store.receive(.fetchData)
    store.receive(.nextRide(.getNextRide(.init(latitude: 20, longitude: 10))))
    
    serviceSubject.send(serviceResponse)
    nextRideSubject.send([])
    testScheduler.advance()
    
    store.receive(.observeConnectionResponse(NetworkPath(status: .satisfied))) {
      $0.hasConnectivity = true
    }
    store.receive(.fetchDataResponse(.success(serviceResponse))) {
      $0.locationsAndChatMessages = .success(serviceResponse)
      $0.socialState = .init(
        chatFeautureState: .init(chatMessages: .results(serviceResponse.chatMessages)),
        twitterFeedState: .init()
      )
      $0.mapFeatureState.riderLocations = serviceResponse.riderLocations
      $0.chatMessageBadgeCount = 6
    }
    store.receive(.nextRide(.nextRideResponse(.success([]))))
    testScheduler.advance(by: 12)
    store.receive(.requestTimer(.timerTicked))
    store.receive(.fetchData)
  
    serviceSubject.send(completion: .failure(testError))
    testScheduler.advance()
    
    store.receive(.fetchDataResponse(.failure(testError))) {
      $0.locationsAndChatMessages = .failure(testError)
    }
    store.receive(.fetchDataResponse(.failure(testError)))
    
    XCTAssertTrue(didRequestAlwaysAuthorization)
    
    // teardown
    store.send(.requestTimer(.stopTimer))
    setSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
    serviceSubject.send(completion: .finished)
    nextRideSubject.send(completion: .finished)
    testScheduler.advance()
}
  
  func test_onAppearWithEnabledLocationServicesRideEventDisabled_shouldNotRequestNextRide() {
    let setSubject = PassthroughSubject<Never, Never>()
    var didRequestAlwaysAuthorization = false
    var didRequestLocation = false
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    let serviceSubject = PassthroughSubject<LocationAndChatMessages, NSError>()
    
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
    let nextRideService: NextRideService = .noop
    var settings = UserDefaultsClient.noop
    
    let rideEventSettings = RideEventSettings(
      isEnabled: false,
      typeSettings: .all,
      eventDistance: .near
    )
    settings.dataForKey = { _ in
      try? rideEventSettings.encoded()
    }
    
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationManagerSubject.eraseToEffect() }
    locationManager.authorizationStatus = { .notDetermined }
    locationManager.locationServicesEnabled = { true }
    locationManager.requestAlwaysAuthorization = { .fireAndForget {
        didRequestAlwaysAuthorization = true
    } }
    locationManager.requestLocation = { .fireAndForget { didRequestLocation = true } }
    locationManager.set = { _ in setSubject.eraseToEffect() }
    
    var environment = AppEnvironment(
      service: service,
      idProvider: .noop,
      mainQueue: testScheduler.eraseToAnyScheduler(),
      locationManager: locationManager,
      nextRideService: nextRideService,
      userDefaultsClient: settings,
      uiApplicationClient: .noop,
      fileClient: .noop,
      setUserInterfaceStyle: { _ in .none },
      pathMonitorClient: .satisfied
    )
    
    let userSettings = UserSettings(
      appearanceSettings: .init(),
      enableObservationMode: false,
      rideEventSettings: rideEventSettings
    )
    environment.fileClient.load = { _ in
        .init(value: try! JSONEncoder().encode(userSettings))
    }
    
    var appState = AppState(settingsState: .init(userSettings: userSettings))
    appState.chatMessageBadgeCount = 3
    
    let store = TestStore(
      initialState: appState,
      reducer: appReducer,
      environment: environment
    )
    
    let serviceResponse: LocationAndChatMessages = .make()
    
    store.send(.onAppear)
    store.receive(.observeConnection)
    store.receive(
      .userSettingsLoaded(.success(userSettings))
    )
    store.receive(.map(.onAppear))
    store.receive(.requestTimer(.startTimer))
    store.receive(.map(.locationRequested)) {
      $0.mapFeatureState.isRequestingCurrentLocation = true
    }
    locationManagerSubject.send(.didChangeAuthorization(.authorizedAlways))
    
    store.receive(.map(.locationManager(.didChangeAuthorization(.authorizedAlways))))
    
    XCTAssertTrue(didRequestLocation)
    locationManagerSubject.send(.didUpdateLocations([currentLocation]))
    
    store.receive(.map(.locationManager(.didUpdateLocations([currentLocation])))) {
      $0.mapFeatureState.isRequestingCurrentLocation = false
      $0.mapFeatureState.location = currentLocation
      $0.didResolveInitialLocation = true
    }
    store.receive(.fetchData)
    
    serviceSubject.send(serviceResponse)
    testScheduler.advance()
    
    store.receive(.observeConnectionResponse(NetworkPath(status: .satisfied))) {
      $0.hasConnectivity = true
    }
    store.receive(.fetchDataResponse(.success(serviceResponse))) {
      $0.locationsAndChatMessages = .success(serviceResponse)
      $0.socialState = .init(
        chatFeautureState: .init(chatMessages: .results(serviceResponse.chatMessages)),
        twitterFeedState: .init()
      )
      $0.mapFeatureState.riderLocations = serviceResponse.riderLocations
      $0.chatMessageBadgeCount = 6
    }
    store.send(.requestTimer(.stopTimer))
    
    XCTAssertTrue(didRequestAlwaysAuthorization)
    
    setSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
    serviceSubject.send(completion: .finished)
    
    testScheduler.advance()
  }
  
  func test_appNavigation() {
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        uiApplicationClient: .noop,
        setUserInterfaceStyle: { _ in .none })
    )
    
    store.send(.setNavigation(tag: .chat)) {
      $0.route = .chat
      XCTAssertTrue($0.isChatViewPresented)
    }
    store.send(.dismissSheetView) {
      $0.route = .none
    }
    store.send(.setNavigation(tag: .rules)) {
      $0.route = .rules
      XCTAssertTrue($0.isRulesViewPresented)
    }
    store.send(.dismissSheetView) {
      $0.route = .none
    }
    store.send(.setNavigation(tag: .settings)) {
      $0.route = .settings
      XCTAssertTrue($0.isSettingsViewPresented)
    }
    store.send(.dismissSheetView) {
      $0.route = .none
    }
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
    
    store.send(.social(.chat(.onAppear))) { state in
      state.chatMessageBadgeCount = 0
    }
  }
    
  func test_animateNextRideBanner() {
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        mainQueue: testScheduler.eraseToAnyScheduler(),
        uiApplicationClient: .noop,
        setUserInterfaceStyle: { _ in .none },
        pathMonitorClient: .satisfied
      )
    )
    
    let ride = Ride(
      id: 123,
      slug: nil,
      title: "Next Ride",
      description: nil,
      dateTime: Date(timeIntervalSince1970: 1234340120),
      location: nil,
      latitude: nil,
      longitude: nil,
      estimatedParticipants: 123,
      estimatedDistance: 312,
      estimatedDuration: 3,
      enabled: true,
      disabledReason: nil,
      disabledReasonMessage: nil,
      rideType: .alleycat
    )
    store.send(.nextRide(.setNextRide(ride))) {
      $0.nextRideState.nextRide = ride
      $0.mapFeatureState.nextRide = ride
    }
    store.receive(.map(.setNextRideBannerVisible(true))) {
      $0.mapFeatureState.isNextRideBannerVisible = true
    }
    testScheduler.advance(by: 1.2)
    store.receive(.map(.setNextRideBannerExpanded(true))) {
      $0.mapFeatureState.isNextRideBannerExpanded = true
    }
    testScheduler.advance(by: 10.0)
    store.receive(.map(.setNextRideBannerExpanded(false))) {
      $0.mapFeatureState.isNextRideBannerExpanded = false
    }
  }
  
  func test_unreadChatMessagesCount() {
    let date: () -> Date = { Date(timeIntervalSinceReferenceDate: 0) }
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        uiApplicationClient: .noop,
        setUserInterfaceStyle: { _ in .none },
        pathMonitorClient: .satisfied
      )
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
    
    store.environment.userDefaultsClient.doubleForKey = { _ in
      date().timeIntervalSince1970
    }
    
    store.send(.fetchDataResponse(.success(response))) { state in
      state.locationsAndChatMessages = .success(response)
      state.socialState.chatFeautureState.chatMessages = .results(response.chatMessages)
      state.mapFeatureState.riderLocations = response.riderLocations
      
      state.chatMessageBadgeCount = 6
    }
    
    store.environment.userDefaultsClient.doubleForKey = { _ in
      date().timeIntervalSince1970 + 14
    }
    
    store.send(.fetchDataResponse(.success(response2))) { state in
      state.locationsAndChatMessages = .success(response2)
      state.socialState.chatFeautureState.chatMessages = .results(response2.chatMessages)
      state.mapFeatureState.riderLocations = response2.riderLocations
      
      state.chatMessageBadgeCount = 1
    }
    store.send(.fetchDataResponse(.success(response3))) { state in
      state.locationsAndChatMessages = .success(response3)
      state.socialState.chatFeautureState.chatMessages = .results(response3.chatMessages)
      state.mapFeatureState.riderLocations = response3.riderLocations
      
      state.chatMessageBadgeCount = 3
    }
    store.send(.setNavigation(tag: .chat)) { state in
      state.route = .chat
      XCTAssertTrue(state.isChatViewPresented)
    }
    store.send(.social(.chat(.onAppear))) { state in
      state.chatMessageBadgeCount = 0
    }
    store.send(.fetchDataResponse(.success(response4))) { state in
      state.locationsAndChatMessages = .success(response4)
      state.socialState.chatFeautureState.chatMessages = .results(response4.chatMessages)
      state.mapFeatureState.riderLocations = response4.riderLocations
      
      state.chatMessageBadgeCount = 0
    }
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
