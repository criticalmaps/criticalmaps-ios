import Combine
import ComposableArchitecture
import ComposableCoreLocation
import Foundation
import MapFeature
import SharedModels
import XCTest

@MainActor
final class MapFeatureCoreTests: XCTestCase {
  let testScheduler = DispatchQueue.test
  
  func test_onAppearAction() async {
    let setSubject = PassthroughSubject<Never, Never>()
    var didRequestAlwaysAuthorization = false
    var didRequestLocation = false
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationManagerSubject.eraseToEffect() }
    locationManager.authorizationStatus = { .notDetermined }
    locationManager.locationServicesEnabled = { true }
    locationManager.requestAlwaysAuthorization = { .fireAndForget {
      didRequestAlwaysAuthorization = true
    } }
    locationManager.requestLocation = { .fireAndForget {
      didRequestLocation = true
    } }
    locationManager.set = { _ in setSubject.eraseToEffect() }
      
    let store = TestStore(
      initialState: MapFeature.State(
        alert: nil,
        isRequestingCurrentLocation: false,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow)
      ),
      reducer: MapFeature()
    )
    store.dependencies.locationManager = locationManager
    
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
    await store.receive(.locationRequested) {
      $0.isRequestingCurrentLocation = true
    }
    XCTAssertTrue(didRequestAlwaysAuthorization)
    // Simulate being given authorized to access location
    
    locationManagerSubject.send(.didChangeAuthorization(.authorizedAlways))
    
    await store.receive(.locationManager(.didChangeAuthorization(.authorizedAlways)))
    XCTAssertTrue(didRequestLocation)
    // Simulate finding the user's current location
    
    locationManagerSubject.send(.didUpdateLocations([currentLocation]))
    
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
    
    setSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
  }
  
  /// if locationServices disabled, test that alert state is set
  func test_disabledLocationService_shouldSetAlert() async {
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    let setSubject = PassthroughSubject<Never, Never>()
    
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationManagerSubject.eraseToEffect() }
    locationManager.authorizationStatus = { .denied }
    locationManager.locationServicesEnabled = { false }
    locationManager.set = { _ in setSubject.eraseToEffect() }
    
    let store = TestStore(
      initialState: MapFeature.State(
        alert: nil,
        isRequestingCurrentLocation: false,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow)
      ),
      reducer: MapFeature()
    )
    store.dependencies.locationManager = locationManager
    
    await store.send(.onAppear)
    // simulate user decision of segmented control
    await store.receive(.locationRequested) {
      $0.isRequestingCurrentLocation = false
      $0.alert = .servicesOff
    }
    setSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
  }
  
  func test_deniedPermission_shouldSetAlert() async {
    var didRequestAlwaysAuthorization = false
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    let setSubject = PassthroughSubject<Never, Never>()
    
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationManagerSubject.eraseToEffect() }
    locationManager.authorizationStatus = { .notDetermined }
    locationManager.locationServicesEnabled = { true }
    locationManager.requestAlwaysAuthorization = { .fireAndForget {
      didRequestAlwaysAuthorization = true
    } }
    locationManager.set = { _ in setSubject.eraseToEffect() }

    let store = TestStore(
      initialState: MapFeature.State(
        alert: nil,
        isRequestingCurrentLocation: false,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow)
      ),
      reducer: MapFeature()
    )
    store.dependencies.locationManager = locationManager
    
    await store.send(.onAppear)
    // simulate user decision of segmented control
    await store.receive(.locationRequested) {
      $0.isRequestingCurrentLocation = true
    }
    XCTAssertTrue(didRequestAlwaysAuthorization)
    // Simulate being given authorized to access location
    locationManagerSubject.send(.didChangeAuthorization(.denied))
    await store.receive(.locationManager(.didChangeAuthorization(.denied))) {
      $0.alert = AlertState(
        title: TextState("Location makes this app better. Please consider giving us access.")
      )
      $0.isRequestingCurrentLocation = false
    }
    setSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
  }
  
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
      reducer: MapFeature()
    )
    store.dependencies.mainQueue = .immediate

    await store.send(.focusNextRide(ride.coordinate)) {
      $0.centerRegion = CoordinateRegion(center: .init(latitude: 13.13, longitude: 55.55))
    }
    await store.receive(.resetCenterRegion) {
      $0.centerRegion = nil
    }
  }
  
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
      reducer: MapFeature()
    )
    store.dependencies.mainQueue = .immediate

    await store.send(.focusRideEvent(ride.coordinate)) {
      $0.eventCenter = .init(
        coordinateRegion: .init(
          center: .init(latitude: 13.13, longitude: 55.55),
          span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
      )
    }
    await store.receive(.resetRideEventCenter) {
      $0.eventCenter = nil
    }
  }

  func test_InfoBanner_appearance() {
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    let setSubject = PassthroughSubject<Never, Never>()
    
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationManagerSubject.eraseToEffect() }
    locationManager.authorizationStatus = { .authorizedAlways }
    locationManager.locationServicesEnabled = { true }
    locationManager.set = { _ in setSubject.eraseToEffect() }
    
    let store = TestStore(
      initialState: MapFeature.State(
        alert: nil,
        isRequestingCurrentLocation: false,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow)
      ),
      reducer: MapFeature()
    )
    
    store.send(.setNextRideBannerVisible(true)) {
      $0.isNextRideBannerVisible = true
    }
    store.send(.setNextRideBannerExpanded(true)) {
      $0.isNextRideBannerExpanded = true
    }
        
    setSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
  }
}
