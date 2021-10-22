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
  
  var rides: [Ride] {
    [
      Ride(
        id: 0,
        slug: nil,
        title: "CriticalMaps Berlin",
        description: nil,
        dateTime: now().addingTimeInterval(36000),
        location: nil,
        latitude: 53.1235,
        longitude: 13.4234,
        estimatedParticipants: nil,
        estimatedDistance: nil,
        estimatedDuration: nil,
        enabled: true,
        disabledReason: nil,
        disabledReasonMessage: nil,
        rideType: .criticalMass
      ),
      Ride(
        id: 0,
        slug: nil,
        title: "CriticalMaps Falkensee",
        description: nil,
        dateTime: now().addingTimeInterval(3600),
        location: "Vorplatz der alten Stadthalle",
        latitude: 53.1235,
        longitude: 13.4234,
        estimatedParticipants: nil,
        estimatedDistance: nil,
        estimatedDuration: nil,
        enabled: true,
        disabledReason: nil,
        disabledReasonMessage: nil,
        rideType: .alleycat
      )
    ]
  }
  let coordinate = Coordinate(latitude: 53.1234, longitude: 13.4233)
  
  func test_disabledNextRideFeature_shouldNotRequestRides() {
    var settings = UserDefaultsClient.noop
    settings.dataForKey = { _ in
      try? RideEventSettings(
        isEnabled: false,
        typeSettings: [],
        radiusSettings: 10
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
      Just(self.rides)
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
      .receive(.nextRideResponse(.success(rides))),
      .receive(.setNextRide(rides[1])) {
        $0.nextRide = self.rides[1]
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
        radiusSettings: 10
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
      .receive(.nextRideResponse(.failure(NextRideService.Failure(internalError: .badRequest))))
    )
  }
  
  func test_getNextRide_shouldNotSetRide_whenRideTypeIsNotEnabled() {
    let service = NextRideService(nextRide: { _, _ in
      Just(self.rides)
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
        radiusSettings: 10
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
      .receive(.nextRideResponse(.success(rides)))
    )
  }
  
  func test_getNextRide_shouldReturnRide_whenRideTypeNil() {
    var ridesWithARideWithNilRideType: [Ride] {
        [
          Ride(
            id: 0,
            slug: nil,
            title: "CriticalMaps Berlin",
            description: nil,
            dateTime: now().addingTimeInterval(36000),
            location: nil,
            latitude: 53.1235,
            longitude: 13.4234,
            estimatedParticipants: nil,
            estimatedDistance: nil,
            estimatedDuration: nil,
            enabled: true,
            disabledReason: nil,
            disabledReasonMessage: nil,
            rideType: .criticalMass
          ),
          Ride(
            id: 0,
            slug: nil,
            title: "CriticalMaps Falkensee",
            description: nil,
            dateTime: now().addingTimeInterval(3600),
            location: "Vorplatz der alten Stadthalle",
            latitude: 53.1235,
            longitude: 13.4234,
            estimatedParticipants: nil,
            estimatedDistance: nil,
            estimatedDuration: nil,
            enabled: true,
            disabledReason: nil,
            disabledReasonMessage: nil,
            rideType: nil
          )
        ]
      }
    let service = NextRideService(nextRide: { _, _ in
      Just(ridesWithARideWithNilRideType)
        .setFailureType(to: NextRideService.Failure.self)
        .eraseToAnyPublisher()
    })
    var settings: UserDefaultsClient = .noop
    settings.dataForKey = { _ in
      try? RideEventSettings.default.encoded()
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
      .receive(.nextRideResponse(.success(ridesWithARideWithNilRideType))),
      .receive(.setNextRide(ridesWithARideWithNilRideType[1])) {
        $0.nextRide = ridesWithARideWithNilRideType[1]
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
        radiusSettings: 10
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
