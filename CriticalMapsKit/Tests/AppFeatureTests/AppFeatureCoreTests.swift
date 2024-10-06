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
import SharedModels
import UserDefaultsClient
import XCTest

final class AppFeatureTests: XCTestCase {
  let testScheduler = DispatchQueue.test
  let testClock = TestClock()
  let date: () -> Date = { @Sendable in Date(timeIntervalSinceReferenceDate: 0) }

  @MainActor
  func test_appNavigation() async {
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() }
    )

    await store.send(.setNavigation(tag: .chat)) {
      $0.route = .chat
      XCTAssertTrue($0.isChatViewPresented)
    }

    await store.send(.setNavigation(tag: .rules)) {
      $0.route = .rules
      XCTAssertTrue($0.isRulesViewPresented)
    }

    await store.send(.setNavigation(tag: .settings)) {
      $0.route = .settings
      XCTAssertTrue($0.isSettingsViewPresented)
    }
  }
  
  @MainActor
  func test_dismissModal_ShouldTriggerFetchChatLocations() async {
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() },
      withDependencies: {
        $0.apiService.getRiders = { [] }
      }
    )
    store.exhaustivity = .off

    await store.send(.dismissSheetView)
    await store.receive(.fetchLocations)
  }

  @MainActor
  func test_animateNextRideBanner() async {
    let testClock = TestClock()

    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() },
      withDependencies: {
        $0.continuousClock = testClock
      }
    )
    store.exhaustivity = .off(showSkippedAssertions: true)

    let ride = Ride.mock1
    await store.send(.nextRide(.setNextRide(ride))) {
      $0.nextRideState.nextRide = ride
      $0.mapFeatureState.nextRide = ride
    }
    await store.receive(.map(.setNextRideBannerVisible(true))) {
      $0.mapFeatureState.isNextRideBannerVisible = true
    }
    await testClock.advance(by: .seconds(1))
    await store.receive(.map(.setNextRideBannerExpanded(true))) {
      $0.mapFeatureState.isNextRideBannerExpanded = true
    }
    await testClock.advance(by: .seconds(8))
    await store.receive(.map(.setNextRideBannerExpanded(false))) {
      $0.mapFeatureState.isNextRideBannerExpanded = false
    }
  }

  @MainActor
  func test_actionSetEventsBottomSheet_setsValue_andMapFeatureRideEvents() async {
    var appState = AppFeature.State()
    let events = [
      Ride.mock1,
      Ride.mock2
    ]
    appState.nextRideState.rideEvents = events

    let store = TestStore(
      initialState: appState,
      reducer: { AppFeature() }
    )

    await store.send(.set(\.$bottomSheetPosition, .dynamicTop)) {
      $0.bottomSheetPosition = .dynamicTop
      $0.mapFeatureState.rideEvents = events
    }
  }

  @MainActor
  func test_actionSetEventsBottomSheet_setsValue_andSetEmptyMapFeatureRideEvents() async {
    var appState = AppFeature.State()
    appState.bottomSheetPosition = .dynamicTop
    let events = [Ride.mock1, .mock2]
    appState.mapFeatureState.rideEvents = events
    
    let store = TestStore(
      initialState: appState,
      reducer: { AppFeature() }
    )
    
    await store.send(.set(\.$bottomSheetPosition, .hidden)) {
      $0.bottomSheetPosition = .hidden
      $0.mapFeatureState.rideEvents = []
    }
  }
  
  @MainActor
  func test_updatingRideEventsSettingRadius_ShouldRefetchNextRideInfo() async throws {
    let testClock = TestClock()
    let testQueue = DispatchQueue.test
    
    var state = AppFeature.State()
    let location = Location(coordinate: .make(), timestamp: 42)
    state.mapFeatureState.location = location
    state.settingsState.rideEventSettings.isEnabled = true
    state.settingsState.rideEventSettings.eventSearchRadius = .close
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.date = .init({ @Sendable in self.date() })
        $0.continuousClock = testClock
        $0.mainQueue = testQueue.eraseToAnyScheduler()
        $0.nextRideService.nextRide = { _, _, _ in
          [.mock1]
        }
        $0.userDefaultsClient.setBool = { _, _ in }
        $0.feedbackGenerator.prepare = {}
        $0.feedbackGenerator.selectionChanged = {}
      }
    )
    store.exhaustivity = .off

    await store.send(.settings(.rideevent(.set(\.$eventSearchRadius, .far)))) {
      $0.settingsState.rideEventSettings.eventSearchRadius = .far
    }
    await testQueue.advance(by: 2)
    await store.receive(.nextRide(.getNextRide(location.coordinate)))
  }
  
  @MainActor
  func test_loadUserSettings_shouldUpdateSettings() async {
    let testClock = TestClock()
    let locationObserver = AsyncStream<LocationManager.Action>.makeStream()
    let sharedModelLocation = SharedModels.Location(
      coordinate: .init(latitude: 11, longitude: 21),
      timestamp: 2
    )
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationObserver.stream }
    locationManager.authorizationStatus = { .notDetermined }
    locationManager.locationServicesEnabled = { true }
    locationManager.requestAlwaysAuthorization = { }
    locationManager.requestLocation = { }
    locationManager.set = { @Sendable _ in }

    var state = AppFeature.State()
    state.nextRideState.userLocation = sharedModelLocation.coordinate
    state.mapFeatureState.location = sharedModelLocation
    
    let userSettings = UserSettings(
      enableObservationMode: false,
      showInfoViewEnabled: false,
      rideEventSettings: .init(
        typeSettings: [.criticalMass: true]
      )
    )
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.uuid = .incrementing
        $0.locationManager = locationManager
        $0.mainQueue = .immediate
        $0.mainRunLoop = .immediate
        $0.date = .init({ @Sendable in self.date() })
        $0.fileClient.load = { @Sendable _ in try! JSONEncoder().encode(userSettings) }
        $0.apiService.getChatMessages = { [] }
        $0.apiService.getRiders = { [] }
        $0.continuousClock = testClock
        $0.nextRideService.nextRide = { _, _, _ in [] }
        $0.userDefaultsClient.setString = { _, _ in }
        $0.observationModeStore.setObservationModeState = { @Sendable _ in }
        $0.feedbackGenerator.prepare = { @Sendable in }
      }
    )
    store.exhaustivity = .off
    
    await store.send(.onAppear)
    await store.receive(.userSettingsLoaded(.success(userSettings))) {
      $0.settingsState = .init(userSettings: userSettings)
    }
  }
  
  @MainActor
  func test_mapAction_didUpdateLocations_shouldFetchNextRide() async {
    let testClock = TestClock()
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() },
      withDependencies: {
        $0.date = .init({ @Sendable in self.date() })
        $0.apiService.postRiderLocation = { _ in .init(status: "ok") }
        $0.continuousClock = testClock
        $0.nextRideService.nextRide = { _, _, _ in
          [.mock1, .mock2]
        }
      }
    )
    
    let location = ComposableCoreLocation.Location(
      coordinate: .init(latitude: 11, longitude: 21),
      timestamp: Date(timeIntervalSince1970: 2)
    )
    let locations: [ComposableCoreLocation.Location] = [location]
    await store.send(.map(.locationManager(.didUpdateLocations(locations)))) {
      $0.mapFeatureState.location = .init(
        coordinate: .init(latitude: 11, longitude: 21),
        timestamp: 2
      )
      $0.nextRideState.userLocation = .init(latitude: 11, longitude: 21)
      $0.didRequestNextRide = true
    }
    await store.receive(.nextRide(.getNextRide(.init(latitude: 11, longitude: 21))))
    await store.receive(.nextRide(.nextRideResponse(.success([.mock1, .mock2])))) {
      $0.nextRideState.rideEvents = [.mock1, .mock2]
    }
    await store.receive(.nextRide(.setNextRide(.mock1))) {
      $0.mapFeatureState.nextRide = .mock1
      $0.nextRideState.nextRide = .mock1
    }
    await store.receive(.map(.setNextRideBannerVisible(true))) {
      $0.mapFeatureState.isNextRideBannerVisible = true
    }
    await testClock.advance(by: .seconds(1))
    await store.receive(.map(.setNextRideBannerExpanded(true))) {
      $0.mapFeatureState.isNextRideBannerExpanded = true
    }
    await testClock.advance(by: .seconds(8))
    await store.receive(.map(.setNextRideBannerExpanded(false))) {
      $0.mapFeatureState.isNextRideBannerExpanded = false
    }
    // should not fetch next Ride on next location update
    let newLocations = [
      Location(
        coordinate: .init(latitude: 13, longitude: 31),
        timestamp: Date(timeIntervalSince1970: 5)
      )
    ]
    await store.send(.map(.locationManager(.didUpdateLocations(newLocations)))) {
      $0.mapFeatureState.location = .init(
        coordinate: .init(latitude: 13, longitude: 31),
        timestamp: 5
      )
      $0.nextRideState.userLocation = .init(latitude: 13, longitude: 31)
    }
  }
  
  @MainActor
  func test_mapAction_focusEvent() async throws {
    var state = AppFeature.State()
    state.bottomSheetPosition = .absolute(1)
    
    let testClock = TestClock()
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.continuousClock = testClock
        $0.mainQueue = .immediate
      }
    )
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    let coordinate = Coordinate.make()
    
    await store.send(.map(.focusRideEvent(coordinate))) {
      $0.mapFeatureState.eventCenter = CoordinateRegion(center: coordinate.asCLLocationCoordinate)
    }
    await store.receive(.binding(.set(\.$bottomSheetPosition, .relative(0.3))))
    await testClock.advance(by: .seconds(1))
    await store.receive(.map(.resetRideEventCenter)) {
      $0.mapFeatureState.eventCenter = nil
    }
  }
  
  @MainActor
  func test_requestTimerTick_fireUpFetchLocations() async {
    var state = AppFeature.State()
    state.requestTimer.secondsElapsed = 59
    state.route = nil
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.continuousClock = TestClock()
        $0.apiService.getRiders = { [] }
      }
    )
    store.exhaustivity = .off
    
    await store.send(.requestTimer(.timerTicked))
    await store.receive(.fetchLocations)
  }
  
  @MainActor
  func test_requestTimerTick_fireUpFetchMessages() async {
    var state = AppFeature.State()
    state.requestTimer.secondsElapsed = 59
    state.route = .chat
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.continuousClock = TestClock()
        $0.apiService.getChatMessages = { [] }
      }
    )
    store.exhaustivity = .off
    
    await store.send(.requestTimer(.timerTicked))
    await store.receive(.fetchChatMessages)
  }
  
  @MainActor
  func test_updatingRideEventSettingEnabled_ShouldRefetchNextRideInfo() async throws {
    let testQueue = DispatchQueue.test
    
    var state = AppFeature.State()
    let location = Location(coordinate: .make(), timestamp: 42)
    state.mapFeatureState.location = location
    state.settingsState.rideEventSettings.isEnabled = true
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.date = .init({ @Sendable in self.date() })
        $0.mainQueue = testQueue.eraseToAnyScheduler()
        $0.nextRideService.nextRide = { _, _, _ in
          [Ride(id: 123, title: "Test", dateTime: Date(timeIntervalSince1970: 0), enabled: true)]
        }
        $0.continuousClock = TestClock()
        $0.userDefaultsClient.setBool = { _, _ in }
      }
    )
    store.exhaustivity = .off

    await store.send(.settings(.rideevent(.set(\.$isEnabled, true)))) {
      $0.settingsState.rideEventSettings.isEnabled = true
    }
    await testQueue.advance(by: 2)
    await store.receive(.nextRide(.getNextRide(location.coordinate)))
  }
  
  @MainActor
  func test_updatingRideEventSettingRadius_ShouldRefetchNextRideInfo() async throws {
    let updatedRaduis = LockIsolated(0)
    let testQueue = DispatchQueue.test
    
    var state = AppFeature.State()
    let location = Location(coordinate: .make(), timestamp: 42)
    state.settingsState.rideEventSettings.eventSearchRadius = .close
    state.mapFeatureState.location = location
    state.settingsState.rideEventSettings.isEnabled = true
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.date = .init({ @Sendable in self.date() })
        $0.mainQueue = testQueue.eraseToAnyScheduler()
        $0.nextRideService.nextRide = { _, radius, _ in
          updatedRaduis.setValue(radius)
          return [Ride(id: 123, title: "Test", dateTime: self.date(), enabled: true)]
        }
        $0.continuousClock = TestClock()
        $0.userDefaultsClient.setBool = { _, _ in }
        $0.feedbackGenerator.selectionChanged = {}
      }
    )
    store.exhaustivity = .off
    
    await store.send(.settings(.rideevent(.set(\.$eventSearchRadius, .far)))) {
      $0.settingsState.rideEventSettings.eventSearchRadius = .far
    }
    await testQueue.advance(by: 2)
    await store.receive(.nextRide(.getNextRide(location.coordinate)))
    
    updatedRaduis.withValue { radius in
      XCTAssertEqual(radius, EventDistance.far.rawValue)
    }
  }

  @MainActor
  func test_viewingModePrompt() async throws {
    let didSetDidShowPrompt = LockIsolated(false)

    let testQueue = DispatchQueue.test

    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() },
      withDependencies: {
        $0.mainQueue = testQueue.eraseToAnyScheduler()
        $0.userDefaultsClient.setBool = { _, _ in
          didSetDidShowPrompt.setValue(true)
          return ()
        }
        $0.continuousClock = TestClock()
      }
    )

    await store.send(.alert(.presented(.observationMode(enabled: false))))

    didSetDidShowPrompt.withValue { val in
      XCTAssertTrue(val)
    }
  }
  
  @MainActor
  func test_postLocation_shouldNotPostLocationWhenObserverModeIsEnabled() async {
    var state = AppFeature.State()
    state.settingsState.isObservationModeEnabled = true
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.date = .init({ @Sendable in self.date() })
        $0.continuousClock = TestClock()
      }
    )
    await store.send(.postLocation)
  }
  
  @MainActor
  func test_bindingObservationStatus_shouldStopLocationUpdating() async {
    let didStopLocationUpdating = LockIsolated(false)
    
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() },
      withDependencies: {
        $0.locationManager.stopUpdatingLocation = { 
          didStopLocationUpdating.setValue(true)
        }
        $0.continuousClock = TestClock()
      }
    )
    store.exhaustivity = .off
    
    await store.send(
      .settings(.binding(.set(\.$isObservationModeEnabled, true)))
    ) {
      $0.settingsState.isObservationModeEnabled = true
    }
    // assert
    let didStopLocationObservationValue = didStopLocationUpdating.value
    XCTAssertTrue(didStopLocationObservationValue)
  }

  @MainActor
  func test_bindingObservationStatus_shouldStartLocationUpdating() async {
    let didStopLocationUpdating = LockIsolated(false)
    
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() },
      withDependencies: {
        $0.locationManager.startUpdatingLocation = {
          didStopLocationUpdating.setValue(true)
        }
        $0.continuousClock = TestClock()
      }
    )
    store.exhaustivity = .off
    
    await store.send(
      .settings(.binding(.set(\.$isObservationModeEnabled, false)))
    ) {
      $0.settingsState.isObservationModeEnabled = false
    }
    // assert
    let didStopLocationObservationValue = didStopLocationUpdating.value
    XCTAssertTrue(didStopLocationObservationValue)
  }
  
  @MainActor
  func test_didTapNextEventBanner() async {
    let store = TestStore(
      initialState: AppFeature.State(nextRideState: NextRideFeature.State(nextRide: Ride.mock1)),
      reducer: { AppFeature() },
      withDependencies: {
        $0.continuousClock = TestClock()
        $0.feedbackGenerator.selectionChanged = {}
      }
    )
    store.exhaustivity = .off
    
    // act
    await store.send(.didTapNextEventBanner)
    
    // assert
    await store.receive(.map(.focusNextRide(Ride.mock1.coordinate)))
    await store.receive(.set(\.$bottomSheetPosition, .relative(0.3)))
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

extension Array where Element == Rider {
  static func make(_ max: Int = 5) -> [Element] {
    var elements = [Element]()
    for index in 0...max {
      elements.append(
        Rider(
          id: String(describing: index),
          coordinate: .init(
            latitude: Double.random(in: 0..<180),
            longitude: Double.random(in: 0..<180)
          ),
          timestamp: Double.random(in: 0..<180)
        )
      )
    }
    return elements
  }
}

extension Array where Element == ChatMessage {
  static func make(_ max: Int = 5) -> [Element] {
    var elements = [Element]()
    for index in 0...max {
      let message = ChatMessage(
        identifier: "ID",
        device: "DEVICE",
        message: "Hello World!",
        timestamp: testDate().timeIntervalSince1970 + Double(index % 2 == 0 ? index : -index)
      )
      elements.append(message)
    }
    return elements
  }
}

extension Ride {
  static let mock1 = Ride(
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
    rideType: .criticalMass
  )
  static let mock2 = Ride(
    id: 3,
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
}
