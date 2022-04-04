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
        locationManager: .unimplemented(
          authorizationStatus: { .notDetermined },
          create: { _ in locationManagerSubject.eraseToEffect() },
          locationServicesEnabled: { true },
          requestAlwaysAuthorization: { _ in
            .fireAndForget { didRequestAlwaysAuthorization = true }
          },
          requestLocation: { _ in .fireAndForget { didRequestLocation = true } },
          set: { _, _ -> Effect<Never, Never> in setSubject.eraseToEffect() }
        ),
        mainQueue: testScheduler.eraseToAnyScheduler()
      )
    )
    
    let currentLocation = Location(
      altitude: 0,
      coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 20),
      course: 0,
      horizontalAccuracy: 0,
      speed: 0,
      timestamp: Date(timeIntervalSince1970: 1_234_567_890),
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
    
    let env = MapFeatureEnvironment(
      locationManager: .unimplemented(
        authorizationStatus: { .denied },
        create: { _ in locationManagerSubject.eraseToEffect() },
        locationServicesEnabled: { false },
        set: { _, _ -> Effect<Never, Never> in setSubject.eraseToEffect() }
      ),
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
    
    let env = MapFeatureEnvironment(
      locationManager: .unimplemented(
        authorizationStatus: { .notDetermined },
        create: { _ in locationManagerSubject.eraseToEffect() },
        locationServicesEnabled: { true },
        requestAlwaysAuthorization: { _ in
            .fireAndForget { didRequestAlwaysAuthorization = true }
        },
        set: { _, _ -> Effect<Never, Never> in setSubject.eraseToEffect() }
      ),
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
      locationManager: .unimplemented(
        authorizationStatus: { fatalError() },
        create: { _ in fatalError() },
        locationServicesEnabled: { fatalError() },
        requestAlwaysAuthorization: { _ in fatalError() },
        set: { _, _ -> Effect<Never, Never> in fatalError() }
      ),
      mainQueue: testScheduler.eraseToAnyScheduler()
    )
    let store = TestStore(
      initialState: MapFeatureState(
        alert: nil,
        isRequestingCurrentLocation: true,
        location: nil,
        riders: [],
        userTrackingMode: .init(userTrackingMode: .follow),
        nextRide: Ride(
          id: 123,
          slug: "SLUG",
          title: "Next Ride",
          dateTime: Date(timeIntervalSinceReferenceDate: 0),
          latitude: 13.13,
          longitude: 55.55,
          enabled: true
        )
      ),
      reducer: mapFeatureReducer,
      environment: env
    )
    
    store.send(.focusNextRide) {
      $0.centerRegion = CoordinateRegion(
        center: .init(latitude: 13.13, longitude: 55.55),
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
      )
    }
    self.testScheduler.advance(by: 1)
    store.receive(.resetCenterRegion) {
      $0.centerRegion = nil
    }
    
  }
  
  func test_InfoBanner_appearance() {
    var didRequestAlwaysAuthorization = false
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    let setSubject = PassthroughSubject<Never, Never>()
    
    let env = MapFeatureEnvironment(
      locationManager: .unimplemented(
        authorizationStatus: { .notDetermined },
        create: { _ in locationManagerSubject.eraseToEffect() },
        locationServicesEnabled: { true },
        requestAlwaysAuthorization: { _ in
            .fireAndForget { didRequestAlwaysAuthorization = true }
        },
        set: { _, _ -> Effect<Never, Never> in setSubject.eraseToEffect() }
      ),
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
