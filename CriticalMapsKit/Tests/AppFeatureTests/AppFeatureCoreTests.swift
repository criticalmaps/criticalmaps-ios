//
//  File.swift
//  
//
//  Created by Malte on 20.06.21.
//

@testable import AppFeature
import Combine
import ComposableArchitecture
import ComposableCoreLocation
import Foundation
import MapFeature
import SharedModels
import XCTest

class AppFeatureTests: XCTestCase {
  let testScheduler = DispatchQueue.test
  
  func test_onAppearAction_shouldSendEffectTimerStart_andMapOnAppear() {
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    let setSubject = PassthroughSubject<Never, Never>()
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        service: .noop,
        idProvider: .noop,
        mainQueue: DispatchQueue.immediate.eraseToAnyScheduler(),
        locationManager: .unimplemented(
          authorizationStatus: { .denied },
          create: { _ in locationManagerSubject.eraseToEffect() },
          locationServicesEnabled: { true },
          set: { (_, _) -> Effect<Never, Never> in setSubject.eraseToEffect() }
        )
      )
    )
    
    store.assert(
      .send(.onAppear),
      .receive(.map(.onAppear)),
      .receive(.requestTimer(.startTimer)),
      .receive(.map(.locationRequested)) {
        $0.mapFeatureState.alert = .goToSettingsAlert
      },
      .send(.requestTimer(.stopTimer)),
      .do {
        setSubject.send(completion: .finished)
        locationManagerSubject.send(completion: .finished)
      }
    )
  }
  
  func test_onAppearWithEnabledLocationServices_shouldSendUserLocation_afterLocatinUpated() {
    let setSubject = PassthroughSubject<Never, Never>()
    var didRequestAlwaysAuthorization = false
    var didRequestLocation = false
    let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
    let serviceSubject = PassthroughSubject<LocationAndChatMessages, LocationsAndChatDataService.Failure>()
    
    let currentLocation = Location(
      altitude: 0,
      coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 20),
      course: 0,
      horizontalAccuracy: 0,
      speed: 0,
      timestamp: Date(timeIntervalSince1970: 1_234_567_890),
      verticalAccuracy: 0
    )
    var service: LocationsAndChatDataService = .noop
    service.getLocations = { _ in
      serviceSubject.eraseToAnyPublisher()
    }
    
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        service: service,
        idProvider: .noop,
        mainQueue: testScheduler.eraseToAnyScheduler(),
        locationManager: .unimplemented(
          authorizationStatus: { .notDetermined },
          create: { _ in locationManagerSubject.eraseToEffect() },
          locationServicesEnabled: { true },
          requestAlwaysAuthorization: { _ in
            .fireAndForget { didRequestAlwaysAuthorization = true }
          },
          requestLocation: { _ in .fireAndForget { didRequestLocation = true } },
          set: { (_, _) -> Effect<Never, Never> in setSubject.eraseToEffect() }
        )
      )
    )
    
    let serviceResponse = LocationAndChatMessages(
      locations: ["ID": .init(coordinate: .init(latitude: 20, longitude: 10), timestamp: 00)],
      chatMessages: ["ID": ChatMessage(message: "Hello World!", timestamp: 0)]
    )
    
    store.assert(
      .send(.onAppear),
      .receive(.map(.onAppear)),
      .receive(.requestTimer(.startTimer)),
      .receive(.map(.locationRequested)) {
        $0.mapFeatureState.isRequestingCurrentLocation = true
      },
      .do {
        locationManagerSubject.send(.didChangeAuthorization(.authorizedAlways))
      },
      .receive(.map(.locationManager(.didChangeAuthorization(.authorizedAlways)))),
      .do { XCTAssertTrue(didRequestLocation) },
      .do {
        locationManagerSubject.send(.didUpdateLocations([currentLocation]))
      },
      .receive(.map(.locationManager(.didUpdateLocations([currentLocation])))) {
        $0.mapFeatureState.isRequestingCurrentLocation = false
        $0.mapFeatureState.location = currentLocation
        $0.didResolveInitialLocation = true
      },
      .receive(.fetchData),
      .do {
        serviceSubject.send(serviceResponse)
        self.testScheduler.advance()
      },
      .receive(.fetchDataResponse(.success(serviceResponse))) {
        $0.locationsAndChatMessages = .success(serviceResponse)
        $0.mapFeatureState.riders = serviceResponse.riders
      },
      .do { self.testScheduler.advance(by: 12) },
      .receive(.requestTimer(.timerTicked)),
      .receive(.fetchData),
      .do {
        serviceSubject.send(completion: .failure(.init(internalError: .badRequest)))
        self.testScheduler.advance()
      },
      .receive(.fetchDataResponse(.failure(.init(internalError: .badRequest)))) {
        $0.locationsAndChatMessages = .failure(.init())
      },
      .receive(.fetchDataResponse(.failure(.init(internalError: .badRequest)))),
               
      .send(.requestTimer(.stopTimer)),
      .do {
        setSubject.send(completion: .finished)
        locationManagerSubject.send(completion: .finished)
        serviceSubject.send(completion: .finished)
      }
    )
  }
}
