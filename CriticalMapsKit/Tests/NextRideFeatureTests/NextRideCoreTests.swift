//
//  File.swift
//  
//
//  Created by Malte on 12.06.21.
//

@testable import NextRideFeature
import Combine
import ComposableArchitecture
import Foundation
import Helpers
import SharedModels
import UserDefaultsClient
import XCTest

class NextRideCoreTests: XCTestCase {
  let now = { Date(timeIntervalSince1970: 0) }
  let testScheduler = DispatchQueue.test
  
  func rides() -> [Ride] {
    [
      Ride(
        id: 0,
        slug: nil,
        title: "CriticalMaps Berlin",
        description: nil,
        dateTime: now().addingTimeInterval(3600),
        location: nil,
        latitude: 53.1235,
        longitude: 13.4234,
        estimatedParticipants: nil,
        estimatedDistance: nil,
        estimatedDuration: nil,
        enabled: true,
        disabledReason: nil,
        disabledReasonMessage: nil,
        rideType: .criticalMass)
    ]
  }
  let coordinate = Coordinate(latitude: 53.1234, longitude: 13.4233)
  
  func test_disabledNextRideFeature_shouldNotRequestRides() {
    var settings = UserDefaultsClient.noop
    settings.dataForKey = { _ in
      try? RideEventSettings(
        isEnabled: false,
        typeSettings: [],
        radiusSettings: RideEventSettings.RideEventRadius(radius: 10, isEnabled: true)
      )
      .encoded()
    }
    // when
    let store = TestStore(
      initialState: NextRideState(),
      reducer: nextRideReducer,
      environment: NextRideEnvironment(
        service: .noop,
        store: settings,
        now: now,
        mainQueue: testScheduler.eraseToAnyScheduler(),
        coordinateObfuscator: .live
      )
    )
    
    store.assert(
      .send(.getNextRide(coordinate))
      // no effect received
    )
  }
  
  func test_getNextRide_shouldReturnMockRide() {
    let service = NextRideService(nextRide: { _, _ in
      Just(self.rides())
        .setFailureType(to: NextRideService.Failure.self)
        .eraseToAnyPublisher()
    })
    var settings: UserDefaultsClient = .noop
    settings.dataForKey = { _ in try? RideEventSettings.default.encoded() }
    // when
    let store = TestStore(
      initialState: NextRideState(),
      reducer: nextRideReducer,
      environment: NextRideEnvironment(
        service: service,
        store: settings,
        now: now,
        mainQueue: testScheduler.eraseToAnyScheduler(),
        coordinateObfuscator: .live
      )
    )
    // then
    store.assert(
      .send(.getNextRide(coordinate)),
      .do { self.testScheduler.advance() },
      .receive(.nextRideResponse(.success(rides()))),
      .receive(.setNextRide(rides()[0])) {
        $0.nextRide = self.rides()[0]
      }
    )
  }
  
  func test_getNextRide_shouldReturnError() {
    let service = NextRideService(nextRide: { _, _ in
      Fail(error: NextRideService.Failure(internalError: .badRequest))
        .eraseToAnyPublisher()
    })
    var settings = UserDefaultsClient.noop
    settings.dataForKey = { _ in
      try? RideEventSettings(
        isEnabled: true,
        typeSettings: [],
        radiusSettings: RideEventSettings.RideEventRadius(radius: 10, isEnabled: true)
      )
      .encoded()
    }
    // when
    let store = TestStore(
      initialState: NextRideState(),
      reducer: nextRideReducer,
      environment: NextRideEnvironment(
        service: service,
        store: settings,
        now: now,
        mainQueue: testScheduler.eraseToAnyScheduler(),
        coordinateObfuscator: .live
      )
    )
    // then
    store.assert(
      .send(.getNextRide(coordinate)),
      .do { self.testScheduler.advance() },
      .receive(.nextRideResponse(.failure(NextRideService.Failure(internalError: .badRequest)))) {
        $0.nextRide = nil
      }
    )
  }
  
  func test_getNextRide_shouldNotSetRide_whenRideTypeIsNotEnabled() {
    let service = NextRideService(nextRide: { _, _ in
      Just(self.rides())
        .setFailureType(to: NextRideService.Failure.self)
        .eraseToAnyPublisher()
    })
    var settings: UserDefaultsClient = .noop
    settings.dataForKey = { _ in
      try? RideEventSettings(
        isEnabled: true,
        typeSettings: [
          RideEventSettings.RideEventTypeSetting(type: Ride.RideType.kidicalMass, isEnabled: true)
        ],
        radiusSettings: RideEventSettings.RideEventRadius(radius: 10, isEnabled: true)
      )
      .encoded()
    }
    // when
    let store = TestStore(
      initialState: NextRideState(),
      reducer: nextRideReducer,
      environment: NextRideEnvironment(
        service: service,
        store: settings,
        now: now,
        mainQueue: testScheduler.eraseToAnyScheduler(),
        coordinateObfuscator: .live
      )
    )
    // then
    store.assert(
      .send(.getNextRide(coordinate)),
      .do { self.testScheduler.advance() },
      .receive(.nextRideResponse(.success(rides()))) {
        $0.nextRide = nil
      }
    )
  }
  
  func test_getNextRide_shouldNotSetRide_whenRideTypeIsEnabledButRideIsCancelled() {
    let rides = [
      Ride(
        id: 0,
        slug: nil,
        title: "CriticalMaps Berlin",
        description: nil,
        dateTime: self.now().addingTimeInterval(3600),
        location: nil,
        latitude: 53.1235,
        longitude: 13.4234,
        estimatedParticipants: nil,
        estimatedDistance: nil,
        estimatedDuration: nil,
        enabled: false,
        disabledReason: nil,
        disabledReasonMessage: nil,
        rideType: .criticalMass
      )
    ]
    let service = NextRideService(nextRide: { _, _ in
      Just(rides)
      .setFailureType(to: NextRideService.Failure.self)
      .eraseToAnyPublisher()
    })
    var settings: UserDefaultsClient = .noop
    settings.dataForKey = { _ in
      try? RideEventSettings(
        isEnabled: true,
        typeSettings: .all,
        radiusSettings: RideEventSettings.RideEventRadius(radius: 10, isEnabled: true)
      )
      .encoded()
    }
    // when
    let store = TestStore(
      initialState: NextRideState(),
      reducer: nextRideReducer,
      environment: NextRideEnvironment(
        service: service,
        store: settings,
        now: now,
        mainQueue: testScheduler.eraseToAnyScheduler(),
        coordinateObfuscator: .live
      )
    )
    // then
    store.assert(
      .send(.getNextRide(coordinate)),
      .do { self.testScheduler.advance() },
      .receive(.nextRideResponse(.success(rides))) {
        $0.nextRide = nil
      }
    )
  }
}
