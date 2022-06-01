import Combine
import ComposableArchitecture
import ComposableCoreLocation
import Foundation
import MapFeature
import SharedModels
import XCTest

class MapFeatureCoreTests: XCTestCase {
  let testScheduler = DispatchQueue.test
  
  func test_onAppearAction() {
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
      initialState: MapFeatureState(
        alert: nil,
        isRequestingCurrentLocation: false,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow)
      ),
      reducer: mapFeatureReducer,
      environment: MapFeatureEnvironment(
        locationManager: locationManager,
        mainQueue: testScheduler.eraseToAnyScheduler()
      )
    )
    
    let currentLocation = Location(
      altitude: 0,
      coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 20),
      course: 0,
      horizontalAccuracy: 0,
      speed: 0,
      timestamp: Date(timeIntervalSince1970: 1234567890),
      verticalAccuracy: 0
    )
    
    store.send(.onAppear)
    // simulate user decision of segmented control
    store.receive(.locationRequested) {
      $0.isRequestingCurrentLocation = true
    }
    XCTAssertTrue(didRequestAlwaysAuthorization)
    // Simulate being given authorized to access location
    
    locationManagerSubject.send(.didChangeAuthorization(.authorizedAlways))
    
    store.receive(.locationManager(.didChangeAuthorization(.authorizedAlways)))
    XCTAssertTrue(didRequestLocation)
    // Simulate finding the user's current location
    
    locationManagerSubject.send(.didUpdateLocations([currentLocation]))
    
    store.receive(.locationManager(.didUpdateLocations([currentLocation]))) {
      $0.isRequestingCurrentLocation = false
      $0.location = currentLocation
    }
    
    setSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
  }
  
  /// if locationServices disabled, test that alert state is set
  func test_disabledLocationService_shouldSetAlert() {
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    let setSubject = PassthroughSubject<Never, Never>()
    
    var locationManager: LocationManager = .failing
    locationManager.delegate = { locationManagerSubject.eraseToEffect() }
    locationManager.authorizationStatus = { .denied }
    locationManager.locationServicesEnabled = { false }
    locationManager.set = { _ in setSubject.eraseToEffect() }
    
    let env = MapFeatureEnvironment(
      locationManager: locationManager,
      mainQueue: testScheduler.eraseToAnyScheduler()
    )
    let store = TestStore(
      initialState: MapFeatureState(
        alert: nil,
        isRequestingCurrentLocation: false,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow)
      ),
      reducer: mapFeatureReducer,
      environment: env
    )
    
    store.send(.onAppear)
    // simulate user decision of segmented control
    store.receive(.locationRequested) {
      $0.isRequestingCurrentLocation = false
      $0.alert = .servicesOff
    }
    setSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
  }
  
  func test_deniedPermission_shouldSetAlert() {
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

    let env = MapFeatureEnvironment(
      locationManager: locationManager,
      mainQueue: testScheduler.eraseToAnyScheduler()
    )
    let store = TestStore(
      initialState: MapFeatureState(
        alert: nil,
        isRequestingCurrentLocation: false,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow)
      ),
      reducer: mapFeatureReducer,
      environment: env
    )
    
    store.send(.onAppear)
    // simulate user decision of segmented control
    store.receive(.locationRequested) {
      $0.isRequestingCurrentLocation = true
    }
    XCTAssertTrue(didRequestAlwaysAuthorization)
    // Simulate being given authorized to access location
    locationManagerSubject.send(.didChangeAuthorization(.denied))
    store.receive(.locationManager(.didChangeAuthorization(.denied))) {
      $0.alert = AlertState(
        title: TextState("Location makes this app better. Please consider giving us access.")
      )
      $0.isRequestingCurrentLocation = false
    }
    setSubject.send(completion: .finished)
    locationManagerSubject.send(completion: .finished)
  }
  
  func test_focusNextRide_setsCenterRegion_andResetsItAfter1Second() {
    let env = MapFeatureEnvironment(
      locationManager: .failing,
      mainQueue: testScheduler.eraseToAnyScheduler()
    )

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
      initialState: MapFeatureState(
        alert: nil,
        isRequestingCurrentLocation: true,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow),
        nextRide: ride
      ),
      reducer: mapFeatureReducer,
      environment: env
    )

    store.send(.focusNextRide(ride.coordinate)) {
      $0.centerRegion = CoordinateRegion(
        center: .init(latitude: 13.13, longitude: 55.55),
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
      )
    }
    testScheduler.advance(by: 1)
    store.receive(.resetCenterRegion) {
      $0.centerRegion = nil
    }
  }
  
  func test_focusRideEvent_setsEventCenter_andResetsItAfter1Second() {
    let env = MapFeatureEnvironment(
      locationManager: .failing,
      mainQueue: testScheduler.eraseToAnyScheduler()
    )

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
      initialState: MapFeatureState(
        alert: nil,
        isRequestingCurrentLocation: true,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow),
        nextRide: ride
      ),
      reducer: mapFeatureReducer,
      environment: env
    )

    store.send(.focusRideEvent(ride.coordinate)) {
      $0.eventCenter = CoordinateRegion(
        center: .init(latitude: 13.13, longitude: 55.55),
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
      )
    }
    testScheduler.advance(by: 1)
    store.receive(.resetRideEventCenter) {
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
    
    let env = MapFeatureEnvironment(
      locationManager: locationManager,
      mainQueue: testScheduler.eraseToAnyScheduler()
    )
    let store = TestStore(
      initialState: MapFeatureState(
        alert: nil,
        isRequestingCurrentLocation: false,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow)
      ),
      reducer: mapFeatureReducer,
      environment: env
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
