import ApiClient
import AppFeature
import Combine
import CombineSchedulers
import ComposableArchitecture
import ComposableCoreLocation
import FileClient
import Foundation
import MapFeature
import NextRideFeature
import PathMonitorClient
import SharedModels
import UserDefaultsClient
import XCTest

@MainActor
final class AppFeatureTests: XCTestCase {
  let testScheduler = DispatchQueue.test
  let date: () -> Date = { Date(timeIntervalSinceReferenceDate: 0) }
  
  func test_onAppearAction_shouldSendEffectTimerStart_andMapOnAppear() async {
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    let setSubject = PassthroughSubject<Never, Never>()
    
    var service: LocationsAndChatDataService = .noop
    service.getLocationsAndSendMessages = { _ in throw testError }
  
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationManagerSubject.eraseToEffect() }
    locationManager.authorizationStatus = { .denied }
    locationManager.locationServicesEnabled = { true }
    locationManager.set = { _ in setSubject.eraseToEffect() }
    
    var userDefaultsClient = UserDefaultsClient.noop
    userDefaultsClient.boolForKey = { _ in
      false
    }
    
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: AppFeature()
    )
    store.dependencies.mainQueue = .immediate
    store.dependencies.date = .constant(date())
    store.dependencies.locationManager = locationManager
    store.dependencies.userDefaultsClient = userDefaultsClient
    store.dependencies.locationAndChatService = service
    store.dependencies.fileClient.load = { @Sendable _ in try! JSONEncoder().encode(UserSettings()) }
    store.dependencies.isNetworkAvailable = true
    
    let task = await store.send(.onAppear)
    await store.receive(.fetchData)
    await store.receive(.connectionObserver(.observeConnection))
    await store.receive(.map(.onAppear))
    await store.receive(.requestTimer(.startTimer)) {
      $0.requestTimer.isTimerActive = true
    }
    await store.receive(.map(.locationRequested)) {
      $0.mapFeatureState.alert = .goToSettingsAlert
    }
    await store.receive(.userSettingsLoaded(.success(.init())))
    await store.receive(.presentObservationModeAlert) {
      $0.alert = .viewingModeAlert
    }
    await store.receive(.fetchDataResponse(.failure(testError))) {
      $0.locationsAndChatMessages = .failure(testError)
    }
    await store.receive(.connectionObserver(.observeConnectionResponse(NetworkPath(status: .satisfied))))
    await store.receive(.requestTimer(.timerTicked))
    await store.receive(.fetchData)
  
    await testScheduler.advance()
    
    await store.receive(.fetchDataResponse(.failure(testError)))
    
    await task.cancel()
    
    setSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
  }
  
  func test_onAppearWithEnabledLocationServices_shouldSendUserLocation_afterLocationUpated() async throws {
    var didRequestAlwaysAuthorization = false
    var didRequestLocation = false
    
    let setSubject = PassthroughSubject<Never, Never>()
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    
    let currentLocation = Location(
      altitude: 0,
      coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 10),
      course: 0,
      horizontalAccuracy: 0,
      speed: 0,
      timestamp: Date(timeIntervalSince1970: 1234567890),
      verticalAccuracy: 0
    )
    
    let serviceResponse: LocationAndChatMessages = .make()
    var service: LocationsAndChatDataService = .noop
    service.getLocationsAndSendMessages = { _ in serviceResponse }

    var userDefaultsClient = UserDefaultsClient.noop
    userDefaultsClient.dataForKey = { _ in
      try? RideEventSettings(
        isEnabled: true,
        typeSettings: [],
        eventDistance: .near
      )
      .encoded()
    }
    userDefaultsClient.boolForKey = { _ in true }
    
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationManagerSubject.eraseToEffect() }
    locationManager.authorizationStatus = { .notDetermined }
    locationManager.locationServicesEnabled = { true }
    locationManager.requestAlwaysAuthorization = { .fireAndForget {
      didRequestAlwaysAuthorization = true
    } }
    locationManager.requestLocation = { .fireAndForget { didRequestLocation = true } }
    locationManager.set = { _ in setSubject.eraseToEffect() }
    
    var appState = AppFeature.State()
    appState.chatMessageBadgeCount = 3
    
    let store = TestStore(
      initialState: appState,
      reducer: AppFeature()
    )
    store.dependencies.date = .constant(date())
    store.dependencies.mainQueue = .immediate
    store.dependencies.locationManager = locationManager
    store.dependencies.userDefaultsClient = userDefaultsClient
    store.dependencies.locationAndChatService = service
    store.dependencies.fileClient.load = { @Sendable _ in try! JSONEncoder().encode(UserSettings()) }
    store.dependencies.isNetworkAvailable = true
    
    let task = await store.send(.onAppear)
    await store.receive(.fetchData)
    await store.receive(.connectionObserver(.observeConnection))
    await store.receive(.map(.onAppear))
    await store.receive(.requestTimer(.startTimer)) {
      $0.requestTimer.isTimerActive = true
    }
    await store.receive(.map(.locationRequested)) {
      $0.mapFeatureState.isRequestingCurrentLocation = true
    }
    await store.receive(.userSettingsLoaded(.success(.init())))
    
    locationManagerSubject.send(.didChangeAuthorization(.authorizedAlways))
    await store.receive(.fetchDataResponse(.success(serviceResponse))) {
      $0.locationsAndChatMessages = .success(serviceResponse)
      $0.socialState = .init(
        chatFeautureState: .init(chatMessages: .results(serviceResponse.chatMessages)),
        twitterFeedState: .init()
      )
      $0.mapFeatureState.riderLocations = serviceResponse.riderLocations
      $0.chatMessageBadgeCount = 6
    }
    await store.receive(.connectionObserver(.observeConnectionResponse(NetworkPath(status: .satisfied))))
    await store.receive(.requestTimer(.timerTicked))
    await store.receive(.fetchData)
    await store.receive(.fetchDataResponse(.success(serviceResponse)))
    await store.receive(.map(.locationManager(.didChangeAuthorization(.authorizedAlways))))

    XCTAssertTrue(didRequestLocation)
    XCTAssertTrue(didRequestAlwaysAuthorization)
    locationManagerSubject.send(.didUpdateLocations([currentLocation]))

    await store.receive(.map(.locationManager(.didUpdateLocations([currentLocation])))) {
      $0.mapFeatureState.isRequestingCurrentLocation = false
      $0.mapFeatureState.location = currentLocation
      $0.didResolveInitialLocation = true
      $0.nextRideState.userLocation = Coordinate(
        latitude: currentLocation.coordinate.latitude,
        longitude: currentLocation.coordinate.longitude
      )
    }

    await store.receive(.fetchData)
    await store.receive(.nextRide(.getNextRide(.init(latitude: 20, longitude: 10))))
    
    try await Task.sleep(nanoseconds: NSEC_PER_SEC / 2)
    
    await store.receive(.fetchDataResponse(.success(serviceResponse)))
    await store.receive(.nextRide(.nextRideResponse(.success([]))))
    
    // teardown
    await task.cancel()
    setSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
    await testScheduler.advance()
  }

  func test_onAppearWithEnabledLocationServicesRideEventDisabled_shouldNotRequestNextRide() async {
    let setSubject = PassthroughSubject<Never, Never>()
    var didRequestAlwaysAuthorization = false
    var didRequestLocation = false
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    
    let mainQueue = DispatchQueue.test
    
    let currentLocation = Location(
      altitude: 0,
      coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 10),
      course: 0,
      horizontalAccuracy: 0,
      speed: 0,
      timestamp: Date(timeIntervalSince1970: 1234567890),
      verticalAccuracy: 0
    )
    
    let serviceResponse: LocationAndChatMessages = .make()
    
    var service: LocationsAndChatDataService = .noop
    service.getLocationsAndSendMessages = { _ in serviceResponse }
    
    var userDefaultsClient = UserDefaultsClient.noop
    userDefaultsClient.boolForKey = { _ in true }
    
    let rideEventSettings = RideEventSettings(
      isEnabled: false,
      typeSettings: .all,
      eventDistance: .near
    )
    userDefaultsClient.dataForKey = { _ in
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
  
    let userSettings = UserSettings(
      appearanceSettings: .init(),
      enableObservationMode: false,
      rideEventSettings: rideEventSettings
    )
    var appState = AppFeature.State(settingsState: .init(userSettings: userSettings))
    appState.chatMessageBadgeCount = 3

    let store = TestStore(
      initialState: appState,
      reducer: AppFeature()
    )
    store.dependencies.mainQueue = mainQueue.eraseToAnyScheduler()
    store.dependencies.locationManager = locationManager
    store.dependencies.locationAndChatService = service
    store.dependencies.userDefaultsClient = userDefaultsClient
    store.dependencies.fileClient.load = { @Sendable _ in try! JSONEncoder().encode(userSettings) }
    store.dependencies.isNetworkAvailable = true
    
    let task = await store.send(.onAppear)
    await store.receive(.fetchData)
    await store.receive(.connectionObserver(.observeConnection))
    await store.receive(.map(.onAppear))
    await store.receive(.requestTimer(.startTimer)) {
      $0.requestTimer.isTimerActive = true
    }
    await store.receive(.map(.locationRequested)) {
      $0.mapFeatureState.isRequestingCurrentLocation = true
    }
    await store.receive(
      .userSettingsLoaded(.success(userSettings))
    )
    locationManagerSubject.send(.didChangeAuthorization(.authorizedAlways))
    
    await store.receive(.fetchDataResponse(.success(serviceResponse))) {
      $0.locationsAndChatMessages = .success(serviceResponse)
      $0.socialState = .init(
        chatFeautureState: .init(chatMessages: .results(serviceResponse.chatMessages)),
        twitterFeedState: .init()
      )
      $0.mapFeatureState.riderLocations = serviceResponse.riderLocations
      $0.chatMessageBadgeCount = 6
    }
    await store.receive(.connectionObserver(.observeConnectionResponse(NetworkPath(status: .satisfied))))
    await store.receive(.map(.locationManager(.didChangeAuthorization(.authorizedAlways))))
    
    XCTAssertTrue(didRequestLocation)
    
    locationManagerSubject.send(.didUpdateLocations([currentLocation]))
    
    await store.receive(.map(.locationManager(.didUpdateLocations([currentLocation])))) {
      $0.mapFeatureState.isRequestingCurrentLocation = false
      $0.mapFeatureState.location = currentLocation
      $0.didResolveInitialLocation = true
      $0.nextRideState.userLocation = Coordinate(
        latitude: currentLocation.coordinate.latitude,
        longitude: currentLocation.coordinate.longitude
      )
    }
    await store.receive(.fetchData)
    
    await testScheduler.advance()
    
    await store.receive(.fetchDataResponse(.success(serviceResponse)))
    await task.cancel()
    
    XCTAssertTrue(didRequestAlwaysAuthorization)
    
    setSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
    
    await testScheduler.advance()
  }
  
  func test_appNavigation() {
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: AppFeature()
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

  func test_resetUnreadMessagesCount_whenAction_chat_onAppear() async {
    var appState = AppFeature.State()
    appState.chatMessageBadgeCount = 13

    let store = TestStore(
      initialState: appState,
      reducer: AppFeature()
    )
    store.dependencies.date = .constant(date())

    await store.send(.social(.chat(.onAppear))) { state in
      state.chatMessageBadgeCount = 0
    }
  }

  func test_animateNextRideBanner() async {
    let testScheduler = DispatchQueue.test
    
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: AppFeature()
    )
    store.dependencies.mainQueue = testScheduler.eraseToAnyScheduler()

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
    await store.send(.nextRide(.setNextRide(ride))) {
      $0.nextRideState.nextRide = ride
      $0.mapFeatureState.nextRide = ride
    }
    await store.receive(.map(.setNextRideBannerVisible(true))) {
      $0.mapFeatureState.isNextRideBannerVisible = true
    }
    await testScheduler.advance(by: 1)
    await store.receive(.map(.setNextRideBannerExpanded(true))) {
      $0.mapFeatureState.isNextRideBannerExpanded = true
    }
    await testScheduler.advance(by: 8)
    await store.receive(.map(.setNextRideBannerExpanded(false))) {
      $0.mapFeatureState.isNextRideBannerExpanded = false
    }
  }
  
  func test_unreadChatMessagesCount() async {
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: AppFeature()
    )
    store.dependencies.date = .constant(date())
    
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
    
    store.dependencies.userDefaultsClient.doubleForKey = { _ in
      self.date().timeIntervalSince1970
    }
    
    await store.send(.fetchDataResponse(.success(response))) { state in
      state.locationsAndChatMessages = .success(response)
      state.socialState.chatFeautureState.chatMessages = .results(response.chatMessages)
      state.mapFeatureState.riderLocations = response.riderLocations
      
      state.chatMessageBadgeCount = 6
    }
    
    await store.dependencies.userDefaultsClient.doubleForKey = { _ in
      self.date().timeIntervalSince1970 + 14
    }
    
    await store.send(.fetchDataResponse(.success(response2))) { state in
      state.locationsAndChatMessages = .success(response2)
      state.socialState.chatFeautureState.chatMessages = .results(response2.chatMessages)
      state.mapFeatureState.riderLocations = response2.riderLocations
      
      state.chatMessageBadgeCount = 1
    }
    await store.send(.fetchDataResponse(.success(response3))) { state in
      state.locationsAndChatMessages = .success(response3)
      state.socialState.chatFeautureState.chatMessages = .results(response3.chatMessages)
      state.mapFeatureState.riderLocations = response3.riderLocations
      
      state.chatMessageBadgeCount = 3
    }
    await store.send(.setNavigation(tag: .chat)) { state in
      state.route = .chat
      XCTAssertTrue(state.isChatViewPresented)
    }
    await store.send(.social(.chat(.onAppear))) { state in
      state.chatMessageBadgeCount = 0
    }
    await store.send(.fetchDataResponse(.success(response4))) { state in
      state.locationsAndChatMessages = .success(response4)
      state.socialState.chatFeautureState.chatMessages = .results(response4.chatMessages)
      state.mapFeatureState.riderLocations = response4.riderLocations
      
      state.chatMessageBadgeCount = 0
    }
  }

  func test_actionSetEventsBottomSheet_setsValue_andMapFeatureRideEvents() {
    var appState = AppFeature.State()
    let events = [
      Ride(
        id: 1,
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
      ),
      Ride(
        id: 2,
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
        rideType: .criticalMass
      )
    ]
    appState.nextRideState.rideEvents = events

    let store = TestStore(
      initialState: appState,
      reducer: AppFeature()
    )

    store.send(.setEventsBottomSheet(true)) {
      $0.presentEventsBottomSheet = true
      $0.mapFeatureState.rideEvents = events
    }
  }

  func test_actionSetEventsBottomSheet_setsValue_andSetEmptyMapFeatureRideEvents() {
    var appState = AppFeature.State()
    let events = [
      Ride(
        id: 1,
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
      ),
      Ride(
        id: 2,
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
        rideType: .criticalMass
      )
    ]
    appState.mapFeatureState.rideEvents = events

    let store = TestStore(
      initialState: appState,
      reducer: AppFeature()
    )

    store.send(.setEventsBottomSheet(false)) {
      $0.presentEventsBottomSheet = false
      $0.mapFeatureState.rideEvents = []
    }
  }

  func test_focuesNextRide_whenAllEventsArePresented_shouldHideAllEventsBotttomSheet() {
    var appState = AppFeature.State()
    appState.presentEventsBottomSheet = true

    let store = TestStore(
      initialState: appState,
      reducer: AppFeature()
    )

    store.send(.map(.focusNextRide(nil)))
    store.receive(.setEventsBottomSheet(false)) {
      $0.presentEventsBottomSheet = false
    }
  }
  
  func test_didSaveUserSettings() async throws {
    let didSaveUserSettings = ActorIsolated(false)
    
    let testQueue = DispatchQueue.test
    
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: AppFeature()
    )
    store.dependencies.mainQueue = testQueue.eraseToAnyScheduler()
    store.dependencies.fileClient.save = { @Sendable _, _ in
      await didSaveUserSettings.setValue(true)
      return ()
    }
    
    await store.send(.setObservationMode(false))
    
    await didSaveUserSettings.withValue { val in
      XCTAssertTrue(val)
    }
  }
  
  func test_viewingModePrompt() async throws {
    let didSetDidShowPrompt = ActorIsolated(false)
    
    let testQueue = DispatchQueue.test
    
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: AppFeature()
    )
    store.dependencies.mainQueue = testQueue.eraseToAnyScheduler()
    store.dependencies.userDefaultsClient.setBool = { _, _ in
      await didSetDidShowPrompt.setValue(true)
      return ()
    }
    
    await store.send(.setObservationMode(false))
    
    await didSetDidShowPrompt.withValue { val in
      XCTAssertTrue(val)
    }
  }
}

// MARK: Helper

let testError = NSError(domain: "", code: 1, userInfo: [:])

extension Coordinate {
  static func make() -> Self {
    let randomDouble: () -> Double = { Double.random(in: 0.0 ... 80.00) }
    return Coordinate(latitude: randomDouble(), longitude: randomDouble())
  }
}

let testDate: () -> Date = { Date(timeIntervalSinceReferenceDate: 0) }

extension Dictionary where Key == String, Value == SharedModels.Location {
  static func make(_ max: Int = 5) -> [Key: Value] {
    let locations = Array(0 ... max).map { index in
      SharedModels.Location(
        coordinate: .make(),
        timestamp: testDate().timeIntervalSince1970 + Double(index % 2 == 0 ? index : -index)
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
    let messages = Array(0 ... max).map { index in
      ChatMessage(
        message: "Hello World!",
        timestamp: testDate().timeIntervalSince1970 + Double(index % 2 == 0 ? index : -index)
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
} // swiftlint:disable:this file_length
