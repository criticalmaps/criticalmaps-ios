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
  let date: () -> Date = { @Sendable in Date(timeIntervalSinceReferenceDate: 0) }

  func test_appNavigation() {
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: AppFeature()
    )

    store.send(.setNavigation(tag: .chat)) {
      $0.route = .chat
      XCTAssertTrue($0.isChatViewPresented)
    }

    store.send(.setNavigation(tag: .rules)) {
      $0.route = .rules
      XCTAssertTrue($0.isRulesViewPresented)
    }

    store.send(.setNavigation(tag: .settings)) {
      $0.route = .settings
      XCTAssertTrue($0.isSettingsViewPresented)
    }
  }
  
  func test_dismissModal_ShouldTriggerFetchChatLocations() async {
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: AppFeature()
    )
    store.exhaustivity = .off

    await store.send(.dismissSheetView)
    await store.receive(.fetchLocations)
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

    store.send(.set(\.$bottomSheetPosition, .dynamicTop)) {
      $0.bottomSheetPosition = .dynamicTop
      $0.mapFeatureState.rideEvents = events
    }
  }

  func test_actionSetEventsBottomSheet_setsValue_andSetEmptyMapFeatureRideEvents() {
    var appState = AppFeature.State()
    appState.bottomSheetPosition = .dynamicTop
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
    
    store.send(.set(\.$bottomSheetPosition, .hidden)) {
      $0.bottomSheetPosition = .hidden
      $0.mapFeatureState.rideEvents = []
    }
  }
  
  func test_updatingRideEventsSettingRadius_ShouldRefetchNextRideInfo() async throws {
    let testQueue = DispatchQueue.test
    
    var state = AppFeature.State()
    let location = Location(coordinate: .make(), timestamp: 42)
    state.mapFeatureState.location = location
    state.settingsState.userSettings.rideEventSettings.isEnabled = true
    state.settingsState.userSettings.rideEventSettings.eventDistance = .close
    
    let store = TestStore(
      initialState: state,
      reducer: AppFeature()
    )
    store.exhaustivity = .off
    store.dependencies.date = .init({ @Sendable in self.date() })
    
    store.dependencies.mainQueue = testQueue.eraseToAnyScheduler()
    store.dependencies.nextRideService.nextRide = { _, _, _ in
      [Ride(id: 123, title: "Test", dateTime: Date(timeIntervalSince1970: 0), enabled: true)]
    }

    await store.send(.settings(.rideevent(.setRideEventRadius(.far)))) {
      $0.settingsState.userSettings.rideEventSettings.eventDistance = .far
    }
    await testQueue.advance(by: 2)
    await store.receive(.nextRide(.getNextRide(location.coordinate)))
  }
  
  func test_mapAction_didUpdateLocations_shouldFireNextRideAndPostLocation() async {
    let location = ComposableCoreLocation.Location(
      coordinate: .init(latitude: 11, longitude: 21),
      timestamp: Date(timeIntervalSince1970: 2)
    )
    let sharedModelLocation = SharedModels.Location(
      coordinate: .init(latitude: 11, longitude: 21),
      timestamp: 2
    )

    var state = AppFeature.State()
    state.settingsState.userSettings.rideEventSettings.isEnabled = true
    state.nextRideState.userLocation = nil
    state.mapFeatureState.location = sharedModelLocation
    
    let store = TestStore(
      initialState: state,
      reducer: AppFeature()
    )
    store.exhaustivity = .off
    store.dependencies.date = .init(date)
        
    let locations: [ComposableCoreLocation.Location] = [location]
    await store.send(.map(.locationManager(.didUpdateLocations(locations)))) {
      $0.mapFeatureState.location = .init(
        coordinate: .init(latitude: 11, longitude: 21),
        timestamp: 2
      )
    }
    await store.receive(.postLocation)
  }
  
  func test_mapAction_didUpdateLocations() async {
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: AppFeature()
    )
    store.exhaustivity = .off
    store.dependencies.date = .init({ @Sendable in self.date() })
    store.dependencies.apiService.postRiderLocation = { _ in .init(status: "ok") }
    
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
    }
    await store.receive(.postLocation)
  }
  
  func test_mapAction_focusEvent() async {
    var state = AppFeature.State()
    state.bottomSheetPosition = .absolute(1)
    
    let store = TestStore(
      initialState: state,
      reducer: AppFeature()
    )
    store.exhaustivity = .off
    store.dependencies.mainQueue = .immediate
    
    let coordinate = Coordinate.make()
    
    await store.send(.map(.focusRideEvent(coordinate))) {
      $0.mapFeatureState.eventCenter = CoordinateRegion(center: coordinate.asCLLocationCoordinate)
    }
    await store.receive(.set(\.$bottomSheetPosition, .relative(0.4))) {
      $0.bottomSheetPosition = .relative(0.4)
    }
  }
  
  func test_requestTimerTick_fireUpFetchLocations() async {
    var state = AppFeature.State()
    state.route = nil
    
    let store = TestStore(
      initialState: state,
      reducer: AppFeature()
    )
    store.exhaustivity = .off
    
    await store.send(.requestTimer(.timerTicked))
    await store.receive(.fetchLocations)
  }
  
  func test_requestTimerTick_fireUpFetchMessages() async {
    var state = AppFeature.State()
    state.route = .chat
    
    let store = TestStore(
      initialState: state,
      reducer: AppFeature()
    )
    store.exhaustivity = .off
    
    await store.send(.requestTimer(.timerTicked))
    await store.receive(.fetchChatMessages)
  }
  
  func test_updatingRideEventSettingEnabled_ShouldRefetchNextRideInfo() async throws {
    let testQueue = DispatchQueue.test
    
    var state = AppFeature.State()
    let location = Location(coordinate: .make(), timestamp: 42)
    state.mapFeatureState.location = location
    state.settingsState.userSettings.rideEventSettings.isEnabled = true
    
    let store = TestStore(
      initialState: state,
      reducer: AppFeature()
    )
    store.exhaustivity = .off
    store.dependencies.date = .init({ @Sendable in self.date() })
    
    store.dependencies.mainQueue = testQueue.eraseToAnyScheduler()
    store.dependencies.nextRideService.nextRide = { _, _, _ in
      [Ride(id: 123, title: "Test", dateTime: Date(timeIntervalSince1970: 0), enabled: true)]
    }

    await store.send(.settings(.rideevent(.setRideEventsEnabled(true)))) {
      $0.settingsState.userSettings.rideEventSettings.isEnabled = true
    }
    await testQueue.advance(by: 2)
    await store.receive(.nextRide(.getNextRide(location.coordinate)))
  }
  
  func test_updatingRideEventSettingRadius_ShouldRefetchNextRideInfo() async throws {
    let updatedRaduis = ActorIsolated(0)
    let testQueue = DispatchQueue.test
    
    var state = AppFeature.State()
    let location = Location(coordinate: .make(), timestamp: 42)
    state.settingsState.userSettings.rideEventSettings.eventDistance = .close
    state.mapFeatureState.location = location
    state.settingsState.userSettings.rideEventSettings.isEnabled = true
    
    let store = TestStore(
      initialState: state,
      reducer: AppFeature()
    )
    store.exhaustivity = .off
    store.dependencies.date = .init({ @Sendable in self.date() })
    store.dependencies.mainQueue = testQueue.eraseToAnyScheduler()
    store.dependencies.nextRideService.nextRide = { _, radius, _ in
      await updatedRaduis.setValue(radius)
      return [Ride(id: 123, title: "Test", dateTime: self.date(), enabled: true)]
    }

    await store.send(.settings(.rideevent(.setRideEventRadius(.far)))) {
      $0.settingsState.userSettings.rideEventSettings.eventDistance = .far
    }
    await testQueue.advance(by: 2)
    await store.receive(.nextRide(.getNextRide(location.coordinate)))
    
    await updatedRaduis.withValue { radius in
      XCTAssertEqual(radius, EventDistance.far.rawValue)
    }
  }

  func test_didSaveUserSettings() async throws {
    let didSaveUserSettings = ActorIsolated(false)
    let didSaveObserverPromptSetting = ActorIsolated(false)

    let testQueue = DispatchQueue.test

    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: AppFeature()
    )
    store.dependencies.mainQueue = testQueue.eraseToAnyScheduler()
    store.dependencies.fileClient.save = { @Sendable _, _ in
      await didSaveUserSettings.setValue(true)
    }
    store.dependencies.userDefaultsClient.setBool = { @Sendable value, _ in
      await didSaveObserverPromptSetting.setValue(value)
    }

    await store.send(.setObservationMode(false))

    await didSaveUserSettings.withValue { val in
      XCTAssertTrue(val, "Expected that save is invoked")
    }
    await didSaveObserverPromptSetting.withValue { val in
      XCTAssertTrue(val, "Expected to store that user prompt has been seen")
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
  
  func test_postLocation_shouldNotPostLocationWhenObserverModeIsEnabled() async {
      var state = AppFeature.State()
      state.settingsState.userSettings.isObservationModeEnabled = true
      
      let store = TestStore(
        initialState: state,
        reducer: AppFeature()
      )
      store.dependencies.date = .init({ @Sendable in self.date() })
      
      let location = ComposableCoreLocation.Location(
        coordinate: .init(latitude: 11, longitude: 21),
        timestamp: Date(timeIntervalSince1970: 2)
      )
      await store.send(.postLocation)
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
