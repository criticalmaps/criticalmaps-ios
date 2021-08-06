//
//  File.swift
//  
//
//  Created by Malte on 15.06.21.
//

@testable import MapFeature
import Combine
import ComposableArchitecture
import ComposableCoreLocation
import Foundation
import SharedModels
import XCTest

class MapFeatureCoreTests: XCTestCase {
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
          set: { (_, _) -> Effect<Never, Never> in setSubject.eraseToEffect() }
        ),
        infobannerController: .mock()
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
    
    store.assert(
      .send(.onAppear),
      // simulate user decision of segmented control
      .receive(.locationRequested) {
        $0.isRequestingCurrentLocation = true
      },
      .do { XCTAssertTrue(didRequestAlwaysAuthorization) },
      // Simulate being given authorized to access location
      .do {
        locationManagerSubject.send(.didChangeAuthorization(.authorizedAlways))
      },
      .receive(.locationManager(.didChangeAuthorization(.authorizedAlways))),
      .do { XCTAssertTrue(didRequestLocation) },
      // Simulate finding the user's current location
      .do {
        locationManagerSubject.send(.didUpdateLocations([currentLocation]))
      },
      .receive(.locationManager(.didUpdateLocations([currentLocation]))) {
        $0.isRequestingCurrentLocation = false
        $0.location = currentLocation
      },
      .do {
        setSubject.send(completion: .finished)
        locationManagerSubject.send(completion: .finished)
      }
    )
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
        set: { (_, _) -> Effect<Never, Never> in setSubject.eraseToEffect() }
      ),
      infobannerController: .mock()
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
    
    store.assert(
      .send(.onAppear),
      // simulate user decision of segmented control
      .receive(.locationRequested) {
        $0.isRequestingCurrentLocation = false
        $0.alert = .servicesOff
      },
      .do {
        setSubject.send(completion: .finished)
        locationManagerSubject.send(completion: .finished)
      }
    )
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
        set: { (_, _) -> Effect<Never, Never> in setSubject.eraseToEffect() }
      ),
      infobannerController: .mock()
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
    
    store.assert(
      .send(.onAppear),
      // simulate user decision of segmented control
      .receive(.locationRequested) {
        $0.isRequestingCurrentLocation = true
      },
      .do { XCTAssertTrue(didRequestAlwaysAuthorization) },
      // Simulate being given authorized to access location
      .do {
        locationManagerSubject.send(.didChangeAuthorization(.denied))
      },
      .receive(.locationManager(.didChangeAuthorization(.denied))) {
        $0.alert = AlertState(
          title: TextState("Location makes this app better. Please consider giving us access.")
        )
        $0.isRequestingCurrentLocation = false
      },
      .do {
        setSubject.send(completion: .finished)
        locationManagerSubject.send(completion: .finished)
      }
    )
  }
  
//  func test_goToSettingsAction_shouldOpenSettingsURL() {
//    var openedUrl: URL!
//    let settingsURL = "settings:weg-li//weg-li/settings"
//    let uiApplicationClient: UIApplicationClient = .init(
//      open: { url, _ in
//        openedUrl = url
//        return .init(value: true)
//      },
//      openSettingsURLString: { settingsURL }
//    )
//    
//    let store = TestStore(
//      initialState: LocationViewState(
//        locationOption: .manual,
//        isMapExpanded: false,
//        isResolvingAddress: false,
//        resolvedAddress: .init(address: .init()),
//        userLocationState: .init()
//      ),
//      reducer: locationReducer,
//      environment: LocationViewEnvironment(
//        locationManager: LocationManager.unimplemented(),
//        placeService: .noop,
//        uiApplicationClient: uiApplicationClient
//      )
//    )
//    
//    store.assert(
//      .send(.goToSettingsButtonTapped)
//    )
//    XCTAssertEqual(openedUrl, URL(string: settingsURL))
//  }
}
