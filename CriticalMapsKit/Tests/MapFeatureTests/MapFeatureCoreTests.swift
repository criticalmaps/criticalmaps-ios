import Combine
import ComposableArchitecture
import ComposableCoreLocation
import Foundation
@testable import MapFeature
import SharedModels
import XCTest

final class MapFeatureCoreTests: XCTestCase {
  let testScheduler = DispatchQueue.test
  
  @MainActor
  func test_onAppearAction() async {
    let didRequestAlwaysAuthorization = LockIsolated(false)
    let didRequestLocation = LockIsolated(false)
    let locationObserver = AsyncStream<LocationManager.Action>.makeStream()
    
    var locationManager = LocationManager.failing
    locationManager.set = { @Sendable _ in }
    locationManager.delegate = { locationObserver.stream }
    locationManager.authorizationStatus = { .notDetermined }
    locationManager.locationServicesEnabled = { true }
    locationManager.requestAlwaysAuthorization = {
      didRequestAlwaysAuthorization.setValue(true)
    }
    locationManager.requestLocation = {
      didRequestLocation.setValue(true)
    }
      
    let store = TestStore(
      initialState: MapFeature.State(
        alert: nil,
        isRequestingCurrentLocation: false,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow)
      ),
      reducer: { MapFeature() }
    )
    store.dependencies.locationManager = locationManager
    
    store.exhaustivity = .off
    
    let currentLocation = Location(
      altitude: 0,
      coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 20),
      course: 0,
      horizontalAccuracy: 0,
      speed: 0,
      timestamp: Date(timeIntervalSince1970: 1234567890),
      verticalAccuracy: 0
    )
    
    await store.send(.onAppear)
    // simulate user decision of segmented control
    await store.receive(.locationRequested)
    let didRequestAlwaysAuthorizationValue = didRequestAlwaysAuthorization.value
    XCTAssertTrue(didRequestAlwaysAuthorizationValue)
    // Simulate being given authorized to access location
    
    locationObserver.continuation.yield(.didChangeAuthorization(.authorizedAlways))
    
    await store.receive(.locationManager(.didChangeAuthorization(.authorizedAlways)))
    let didRequestLocationValue = didRequestLocation.value
    XCTAssertTrue(didRequestLocationValue)
    // Simulate finding the user's current location
    
    locationObserver.continuation.yield(.didUpdateLocations([currentLocation]))
    
    await store.receive(.locationManager(.didUpdateLocations([currentLocation]))) {
      $0.isRequestingCurrentLocation = false
      $0.location = Location(
        coordinate: Coordinate(
          latitude: currentLocation.coordinate.latitude,
          longitude: currentLocation.coordinate.longitude
        ),
        timestamp: currentLocation.timestamp.timeIntervalSince1970
      )
    }
  }
  
  /// if locationServices disabled, test that alert state is set
  @MainActor
  func test_disabledLocationService_shouldSetAlert() async {
    let locationObserver = AsyncStream<LocationManager.Action>.makeStream()
    
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationObserver.stream }
    locationManager.authorizationStatus = { .denied }
    locationManager.locationServicesEnabled = { false }
    locationManager.set = { @Sendable _ in }
    
    let store = TestStore(
      initialState: MapFeature.State(
        alert: nil,
        isRequestingCurrentLocation: false,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow)
      ),
      reducer: { MapFeature() }
    )
    store.dependencies.locationManager = locationManager
    store.exhaustivity = .off
    
    await store.send(.onAppear)
    // simulate user decision of segmented control
    await store.receive(.locationRequested)
    await store.receive(.setAlert(.goToSettingsAlert)) {
      $0.alert = .goToSettingsAlert
    }
    
    locationObserver.continuation.finish()
  }
  
  @MainActor
  func test_deniedPermission_shouldSetAlert() async {
    let didRequestAlwaysAuthorization = LockIsolated(false)
    let locationObserver = AsyncStream<LocationManager.Action>.makeStream()
    
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationObserver.stream }
    locationManager.authorizationStatus = { .notDetermined }
    locationManager.locationServicesEnabled = { true }
    locationManager.requestAlwaysAuthorization = {
      didRequestAlwaysAuthorization.setValue(true)
    }
    locationManager.set = { @Sendable _ in }

    let store = TestStore(
      initialState: MapFeature.State(
        alert: nil,
        isRequestingCurrentLocation: false,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow)
      ),
      reducer: { MapFeature() }
    )
    store.dependencies.locationManager = locationManager
    store.exhaustivity = .off
    
    await store.send(.onAppear)
    // simulate user decision of segmented control
    await store.receive(.locationRequested)
    let didRequestAlwaysAuthorizationValue = didRequestAlwaysAuthorization.value
    XCTAssertTrue(didRequestAlwaysAuthorizationValue)
    // Simulate being given authorized to access location
    locationObserver.continuation.yield(.didChangeAuthorization(.denied))
    await store.receive(.locationManager(.didChangeAuthorization(.denied))) {
      $0.alert = AlertState(
        title: { TextState("Location makes this app better. Please consider giving us access.") }
      )
      $0.isRequestingCurrentLocation = false
    }
  }
  
  @MainActor
  func test_focusNextRide_setsCenterRegion_andResetsItAfter1Second() async {
    let ride = Ride(
      id: 123,
      slug: "SLUG",
      title: "Next Ride",
      dateTime: Date(timeIntervalSinceReferenceDate: 0),
      latitude: 13.13,
      longitude: 55.55,
      enabled: true
    )

    let store = TestStore(
      initialState: MapFeature.State(
        alert: nil,
        isRequestingCurrentLocation: true,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow),
        nextRide: ride
      ),
      reducer: { MapFeature() }
    )
    store.dependencies.mainQueue = .immediate
    let testClock = TestClock()
    store.dependencies.continuousClock = testClock
    store.exhaustivity = .off

    await store.send(.focusNextRide(ride.coordinate)) {
      $0.centerRegion = CoordinateRegion(center: .init(latitude: 13.13, longitude: 55.55))
    }
    await testClock.advance(by: .seconds(1))
    await store.receive(.resetCenterRegion) {
      $0.centerRegion = nil
    }
  }
  
  @MainActor
  func test_focusRideEvent_setsEventCenter_andResetsItAfter1Second() async {
    let ride = Ride(
      id: 123,
      slug: "SLUG",
      title: "Next Ride",
      dateTime: Date(timeIntervalSinceReferenceDate: 0),
      latitude: 13.13,
      longitude: 55.55,
      enabled: true
    )

    let store = TestStore(
      initialState: MapFeature.State(
        alert: nil,
        isRequestingCurrentLocation: true,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow),
        nextRide: ride
      ),
      reducer: { MapFeature() }
    )
    store.dependencies.mainQueue = .immediate
    let testClock = TestClock()
    store.dependencies.continuousClock = testClock
    store.exhaustivity = .off

    await store.send(.focusRideEvent(ride.coordinate)) {
      $0.eventCenter = .init(
        coordinateRegion: .init(
          center: .init(latitude: 13.13, longitude: 55.55),
          span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
      )
    }
    await testClock.advance(by: .seconds(1))
    await store.receive(.resetRideEventCenter) {
      $0.eventCenter = nil
    }
  }

  @MainActor
  func test_InfoBanner_appearance() async {
    let locationObserver = AsyncStream<LocationManager.Action>.makeStream()
    
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationObserver.stream }
    locationManager.authorizationStatus = { .authorizedAlways }
    locationManager.locationServicesEnabled = { true }
    locationManager.set = { @Sendable _ in }
    
    let store = TestStore(
      initialState: MapFeature.State(
        alert: nil,
        isRequestingCurrentLocation: false,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow)
      ),
      reducer: { MapFeature() }
    )
    
    await store.send(.setNextRideBannerVisible(true)) {
      $0.isNextRideBannerVisible = true
    }
    await store.send(.setNextRideBannerExpanded(true)) {
      $0.isNextRideBannerExpanded = true
    }
  }
}
