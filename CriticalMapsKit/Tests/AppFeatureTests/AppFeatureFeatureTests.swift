import ApiClient
@testable import AppFeature
import Combine
import CombineSchedulers
import ComposableArchitecture
import ComposableCoreLocation
import Foundation
import MapFeature
import NextRideFeature
import SettingsFeature
import SharedModels
import SocialFeature
import Testing
import UserDefaultsClient

// swiftlint:disable:next type_body_length
@Suite
@MainActor
struct AppFeatureTests {
  let testScheduler = DispatchQueue.test
  let testClock = TestClock()
  let date: () -> Date = { @Sendable in Date(timeIntervalSinceReferenceDate: 0) }
  
  @Test
  func appNavigation() async {
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() }
    )

    await store.send(.socialButtonTapped) {
      $0.destination = .social(SocialFeature.State())
    }

    await store.send(.settingsButtonTapped) {
      $0.destination = .settings(SettingsFeature.State())
    }
  }
  
  @Test
  func dismissModal_ShouldTriggerFetchChatLocations() async {
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() },
      withDependencies: {
        $0.apiService.getRiders = { [] }
      }
    )

    await store.send(.dismissDestination)
  }

  @Test
  func animateNextRideBanner() async {
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
    await store.receive(\.map.setNextRideBannerVisible) {
      $0.mapFeatureState.isNextRideBannerVisible = true
    }
  }

  @Test
  func actionSetEventsBottomSheet_setsValue_andMapFeatureRideEvents() async {
    var appState = AppFeature.State()
    let events = [
      Ride.mock1,
      Ride.mock2
    ]
    appState.nextRideState.rideEvents = events

    let store = TestStore(
      initialState: appState,
      reducer: { AppFeature() }
    ) {
      $0.feedbackGenerator = .noop
    }

    await store.send(.didTapNextRideOverlayButton) {
      $0.mapFeatureState.rideEvents = events
      $0.isEventListPresented = true
    }
    
    await store.receive(\.map.focusNextRide)
  }

  @Test
  func actionSetEventsBottomSheet_setsValue_andSetEmptyMapFeatureRideEvents() async {
    var appState = AppFeature.State()
    let events = [
      Ride.mock1,
      Ride.mock2
    ]
    appState.nextRideState.rideEvents = events

    let store = TestStore(
      initialState: appState,
      reducer: { AppFeature() }
    ) {
      $0.feedbackGenerator = .noop
    }

    await store.send(.didTapNextRideOverlayButton) {
      $0.mapFeatureState.rideEvents = events
      $0.isEventListPresented = true
    }
    await store.receive(\.map.focusNextRide)
    
    await store.send(.dismissEventList) {
      $0.isEventListPresented = false
      $0.mapFeatureState.rideEvents = []
    }
  }
  
  @Test
  func updatingRideEventsSettingRadius_ShouldRefetchNextRideInfo() async throws {
    let testQueue = DispatchQueue.test
    
    var state = AppFeature.State()
    let location = Location(coordinate: .make(), timestamp: 42)
    state.mapFeatureState.location = location
    state.$rideEventSettings.withLock { $0.isEnabled = true }
    state.$rideEventSettings.withLock { $0.eventDistance = .close }
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.date = .constant(date())
        $0.continuousClock = ImmediateClock()
        $0.mainQueue = testQueue.eraseToAnyScheduler()
        $0.nextRideService.nextRide = { _, _, _ in
          [.mock1]
        }
        $0.userDefaultsClient.setBool = { _, _ in }
        $0.feedbackGenerator.prepare = {}
        $0.feedbackGenerator.selectionChanged = {}
        $0.coordinateObfuscator = .previewValue
      }
    )
    store.exhaustivity = .off

    await store.send(.settingsButtonTapped)
    await store.send(.destination(.presented(.settings(.view(.rideEventSettingsRowTapped)))))
    await store.send(
      .destination(
        .presented(
          .settings(
            .destination(
              .presented(
                .rideEventSettings(
                  .binding(.set(\.eventSearchRadius, .far))
                )
              )
            )
          )
        )
      )
    ) {
      $0.settingsState.$rideEventSettings.withLock { $0.eventDistance = .far }
      $0.$rideEventSettings.withLock { $0.eventDistance = .far }
    }
    await testQueue.advance(by: 2)
    await store.receive(\.nextRide.getNextRide)
  }
  
  @Test
  func loadUserSettings_shouldUpdateSettings() async {
    let locationObserver = AsyncStream<LocationManager.Action>.makeStream()
    let sharedModelLocation = SharedModels.Location(
      coordinate: .init(latitude: 11, longitude: 21),
      timestamp: 2
    )
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationObserver.stream }
    locationManager.authorizationStatus = { .notDetermined }
    locationManager.locationServicesEnabled = { true }
    locationManager.requestAlwaysAuthorization = {}
    locationManager.requestLocation = {}
    locationManager.set = { @Sendable _ in }

    var state = AppFeature.State()
    state.nextRideState.userLocation = sharedModelLocation.coordinate
    state.mapFeatureState.location = sharedModelLocation
    
    let userSettings = UserSettings(
      enableObservationMode: false,
      showInfoViewEnabled: false
    )
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.uuid = .incrementing
        $0.locationManager = locationManager
        $0.mainQueue = .immediate
        $0.mainRunLoop = .immediate
        $0.date = .constant(date())
        $0.apiService.getChatMessages = { [] }
        $0.apiService.getRiders = { [] }
        $0.continuousClock = ImmediateClock()
        $0.nextRideService.nextRide = { _, _, _ in [] }
        $0.userDefaultsClient.setString = { _, _ in }
        $0.userDefaultsClient.boolForKey = { _ in false }
        $0.feedbackGenerator.prepare = { @Sendable in }
        $0.uiApplicationClient.setUserInterfaceStyle = { _ in }
      }
    )
    store.exhaustivity = .off
    
    await store.send(.onAppear)
  }
  
  @Test
  func mapAction_didUpdateLocations_shouldFetchNextRide() async {
    let testClock = TestClock()
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() },
      withDependencies: {
        $0.date = .constant(date())
        $0.apiService.postRiderLocation = { _ in .init(status: "ok") }
        $0.continuousClock = testClock
        $0.nextRideService.nextRide = { _, _, _ in
          [.mock1, .mock2]
        }
        $0.coordinateObfuscator = .previewValue
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
    await store.receive(\.nextRide.getNextRide)
    await store.receive(\.nextRide.nextRideResponse) {
      $0.nextRideState.rideEvents = [.mock1, .mock2]
    }
    await store.receive(\.nextRide.setNextRide) {
      $0.mapFeatureState.nextRide = .mock1
      $0.nextRideState.nextRide = .mock1
    }
    await store.receive(\.map.setNextRideBannerVisible) {
      $0.mapFeatureState.isNextRideBannerVisible = true
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
  
  @Test
  func mapAction_focusEvent() async throws {
    let state = AppFeature.State()
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
    await testClock.advance(by: .seconds(1))
    await store.receive(\.map.resetRideEventCenter) {
      $0.mapFeatureState.eventCenter = nil
    }
  }
  
  @Test("Full cycle triggers fetch locations")
  func requestTimerFullCycle_fireUpFetchLocations() async {
    let state = AppFeature.State()

    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.continuousClock = ImmediateClock()
        $0.apiService.getRiders = { [] }
        $0.date = .constant(date())
      }
    )
    store.exhaustivity = .off

    await store.send(.requestTimer(.fullCycle))
    await store.receive(\.fetchLocations)
  }
  
  @Test("Full cycle triggers fetch messages when social view is open")
  func requestTimerFullCycle_fireUpFetchMessages() async {
    var state = AppFeature.State()
    state.destination = .social(SocialFeature.State())

    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.continuousClock = ImmediateClock()
        $0.apiService.getChatMessages = { [] }
        $0.apiService.getRiders = { [] }
        $0.date = .constant(date())
      }
    )
    store.exhaustivity = .off

    await store.send(.requestTimer(.fullCycle))
    await store.receive(\.fetchChatMessages)
  }
  
  @Test
  func updatingRideEventSettingEnabled_ShouldRefetchNextRideInfo() async throws {
    let testQueue = DispatchQueue.test
    
    var state = AppFeature.State()
    let location = Location(coordinate: .make(), timestamp: 42)
    state.mapFeatureState.location = location
    state.$rideEventSettings.withLock { $0.isEnabled = true }
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.date = .constant(date())
        $0.mainQueue = testQueue.eraseToAnyScheduler()
        $0.nextRideService.nextRide = { _, _, _ in
          [Ride(id: 123, title: "Test", dateTime: Date(timeIntervalSince1970: 0), enabled: true)]
        }
        $0.continuousClock = ImmediateClock()
        $0.userDefaultsClient.setBool = { _, _ in }
        $0.coordinateObfuscator = .previewValue
      }
    )
    store.exhaustivity = .off

    await store.send(.settingsButtonTapped)
    await store.send(.destination(.presented(.settings(.view(.rideEventSettingsRowTapped)))))
    await store.send(
      .destination(
        .presented(
          .settings(
            .destination(
              .presented(
                .rideEventSettings(
                  .binding(.set(\.isEnabled, true))
                )
              )
            )
          )
        )
      )
    ) {
      $0.$rideEventSettings.withLock { $0.isEnabled = true }
    }
    await testQueue.advance(by: 2)
    await store.receive(\.nextRide.getNextRide)
  }
  
  @Test
  func updatingRideEventSettingRadius_ShouldRefetchNextRideInfo() async throws {
    let updatedRaduis = LockIsolated(0)
    let testQueue = DispatchQueue.test
    
    var state = AppFeature.State()
    let location = Location(coordinate: .make(), timestamp: 42)
    state.$rideEventSettings.withLock { $0.eventDistance = .close }
    state.mapFeatureState.location = location
    state.$rideEventSettings.withLock { $0.isEnabled = true }
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.date = .constant(date())
        $0.mainQueue = testQueue.eraseToAnyScheduler()
        $0.nextRideService.nextRide = { _, radius, _ in
          updatedRaduis.setValue(radius)
          return [Ride(id: 123, title: "Test", dateTime: date(), enabled: true)]
        }
        $0.continuousClock = ImmediateClock()
        $0.userDefaultsClient.setBool = { _, _ in }
        $0.feedbackGenerator.selectionChanged = {}
        $0.coordinateObfuscator = .previewValue
      }
    )
    store.exhaustivity = .off
    
    await store.send(.settingsButtonTapped)
    await store.send(.destination(.presented(.settings(.view(.rideEventSettingsRowTapped)))))
    await store.send(
      .destination(
        .presented(
          .settings(
            .destination(
              .presented(
                .rideEventSettings(
                  .binding(.set(\.eventSearchRadius, .far))
                )
              )
            )
          )
        )
      )
    ) { $0.$rideEventSettings.withLock { $0.eventDistance = .far } }
    await testQueue.advance(by: 2)
    await store.receive(\.nextRide.getNextRide)
    
    updatedRaduis.withValue { radius in
      #expect(radius == EventDistance.far.rawValue)
    }
  }

  var cancellables: Set<AnyCancellable> = []
  
  @Test
  mutating func viewingModePrompt() async throws {
    let testQueue = DispatchQueue.test

    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() },
      withDependencies: {
        $0.mainQueue = testQueue.eraseToAnyScheduler()
        $0.continuousClock = ImmediateClock()
      }
    )
    
    var didUpdateSettings: [Bool] = []
    store.state.$userSettings
      .publisher
      .dropFirst()
      .sink { didUpdateSettings.append($0.isObservationModeEnabled) }
      .store(in: &cancellables)
             
    await store.send(.settingsButtonTapped) {
      $0.destination = .settings(SettingsFeature.State())
    }
    await store.send(
      .destination(
        .presented(
          .alert(.setObservationMode(enabled: false))
        )
      )
    )
    #expect(didUpdateSettings == [false])
  }
  
  @Test
  func postLocation_shouldNotPostLocationWhenObserverModeIsEnabled() async {
    let state = AppFeature.State()
    state.$userSettings.withLock { $0.isObservationModeEnabled = true }
    
    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.date = .constant(date())
        $0.continuousClock = ImmediateClock()
      }
    )
    await store.send(.postLocation)
  }
  
  @Test("Halfway point triggers post location")
  func requestTimerHalfwayPoint_triggersPostLocation() async {
    let state = AppFeature.State()

    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.continuousClock = ImmediateClock()
        $0.idProvider.id = { "test-device-id" }
        $0.date = .constant(date())
        $0.apiService.postRiderLocation = { _ in ApiResponse(status: nil) }
      }
    )
    store.exhaustivity = .off

    await store.send(.requestTimer(.halfwayPoint))
    await store.receive(\.postLocation)
  }

  @Test("Location should not be sent when it is in a privacy zone")
  func postLocation_shouldNotPostLocationWhenInPrivacyZone() async {
    let randomCoordinate = Coordinate.make()

    @Shared(.userSettings) var userSettings = UserSettings()
    @Shared(.privacyZoneSettings) var zones = PrivacyZoneSettings(
      isEnabled: true,
      zones: [
        PrivacyZone(
          id: UUID(),
          name: "Home",
          center: .init(latitude: randomCoordinate.latitude, longitude: randomCoordinate.longitude),
          radius: 400,
          isActive: true,
          createdAt: .now
        )
      ],
      defaultRadius: 400,
      shouldShowZonesOnMap: false
    )

    var state = AppFeature.State()
    state.mapFeatureState.location = SharedModels.Location(
      coordinate: randomCoordinate,
      timestamp: 1423423423423,
      name: "test",
      color: "#001122"
    )
    state.destination = nil

    let store = TestStore(
      initialState: state,
      reducer: { AppFeature() },
      withDependencies: {
        $0.continuousClock = ImmediateClock()
      }
    )

    // Location is in privacy zone, should not post
    await store.send(.postLocation)
  }
  
  @Test
  func bindingObservationStatus_shouldStopLocationUpdating() async {
    let didStopLocationUpdating = LockIsolated(false)
    
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() },
      withDependencies: {
        $0.locationManager.stopUpdatingLocation = { 
          didStopLocationUpdating.setValue(true)
        }
        $0.continuousClock = ImmediateClock()
      }
    )
    store.exhaustivity = .off
    
    await store.send(.settingsButtonTapped)
    await store.send(
      .destination(
        .presented(
          .settings(
            .binding(.set(\.userSettings.isObservationModeEnabled, true))
          )
        )
      )
    ) {
      $0.$userSettings.withLock { $0.isObservationModeEnabled = true }
    }
    // assert
    let didStopLocationObservationValue = didStopLocationUpdating.value
    #expect(didStopLocationObservationValue)
  }

  @Test
  func bindingObservationStatus_shouldStartLocationUpdating() async {
    let didStopLocationUpdating = LockIsolated(false)
    
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() },
      withDependencies: {
        $0.locationManager.stopUpdatingLocation = {
          didStopLocationUpdating.setValue(true)
        }
        $0.continuousClock = ImmediateClock()
      }
    )
    store.exhaustivity = .off
    
    await store.send(.settingsButtonTapped)
    await store.send(
      .destination(
        .presented(
          .settings(
            .binding(.set(\.userSettings.isObservationModeEnabled, true))
          )
        )
      )
    ) {
      $0.$userSettings.withLock { $0.isObservationModeEnabled = true }
    }

    // assert
    let didStopLocationObservationValue = didStopLocationUpdating.value
    #expect(didStopLocationObservationValue)
  }
  
  @Test
  func didTapNextEventBanner() async {
    let store = TestStore(
      initialState: AppFeature.State(nextRideState: NextRideFeature.State(nextRide: Ride.mock1)),
      reducer: { AppFeature() },
      withDependencies: {
        $0.continuousClock = ImmediateClock()
        $0.feedbackGenerator.selectionChanged = {}
      }
    )
    store.exhaustivity = .off
    
    // act
    await store.send(.didTapNextRideOverlayButton)
    
    // assert
    await store.receive(\.map.focusNextRide)
  }
}
