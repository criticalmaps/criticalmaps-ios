import Combine
import ComposableArchitecture
import Foundation
import Helpers
@testable import NextRideFeature
import SharedModels
import UserDefaultsClient
import XCTest

// swiftlint:disable:next type_body_length
final class NextRideCoreTests: XCTestCase {
  let now = {
    Calendar.current.date(
      from: .init(
        timeZone: .init(secondsFromGMT: 0),
        year: 2022,
        month: 3,
        day: 25,
        hour: 12
      )
    )!
  }

  let testScheduler = DispatchQueue.immediate
  
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
        eventDistance: .near
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
    
    // no effect received
    store.send(.getNextRide(coordinate))
  }
  
  func test_getNextRide_shouldReturnMockRide() {
    let service = NextRideService(nextRide: { _, _, _ in
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
    store.send(.getNextRide(coordinate))
    store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = self.rides.sortByDateAndFilterBeforeDate(store.environment.now)
    }
    store.receive(.setNextRide(rides[1])) {
      $0.nextRide = self.rides[1]
    }
  }
  
  func test_getNextRide_shouldReturnError() {
    let service = NextRideService(nextRide: { _, _, _ in
      Fail(error: NextRideService.Failure(internalError: .badRequest))
        .eraseToAnyPublisher()
    })
    var settings = UserDefaultsClient.noop
    settings.dataForKey = { _ in
      try? RideEventSettings(
        isEnabled: true,
        typeSettings: [],
        eventDistance: .near
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
    store.send(.getNextRide(coordinate))
    store.receive(.nextRideResponse(.failure(NextRideService.Failure(internalError: .badRequest))))
  }
  
  func test_getNextRide_shouldNotSetRide_whenRideTypeIsNotEnabled() {
    let service = NextRideService(nextRide: { _, _, _ in
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
        eventDistance: .near
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
    store.send(.getNextRide(coordinate))
    store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = self.rides.sortByDateAndFilterBeforeDate(store.environment.now)
    }
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
    let service = NextRideService(nextRide: { _, _, _ in
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
    store.send(.getNextRide(coordinate))
    store.receive(.nextRideResponse(.success(ridesWithARideWithNilRideType))) {
      $0.rideEvents = ridesWithARideWithNilRideType.sortByDateAndFilterBeforeDate(store.environment.now)
    }
    store.receive(.setNextRide(ridesWithARideWithNilRideType[1])) {
      $0.nextRide = ridesWithARideWithNilRideType[1]
    }
  }
  
  func test_getNextRide_shouldNotSetRide_whenRideTypeIsEnabledButRideIsCancelled() {
    let rides = [
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
        enabled: false,
        disabledReason: nil,
        disabledReasonMessage: nil,
        rideType: .criticalMass
      )
    ]
    let service = NextRideService(nextRide: { _, _, _ in
      Just(rides)
        .setFailureType(to: NextRideService.Failure.self)
        .eraseToAnyPublisher()
    })
    var settings: UserDefaultsClient = .noop
    settings.dataForKey = { _ in
      try? RideEventSettings.default
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
    store.send(.getNextRide(coordinate))
    store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = rides
      $0.nextRide = nil
    }
  }
  
  var firstOfApril: Date {
    Calendar.current.date(
      from: .init(
        timeZone: .init(secondsFromGMT: 0),
        year: 2022,
        month: 4,
        day: 1,
        hour: 20
      )
    )!
  }
  
  func test_getNextRide_returnRideFromThisMonth_whenTodayIsFriday() {
    let rides = [
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
        rideType: .criticalMass
      ),
      Ride(
        id: 0,
        slug: nil,
        title: "Critical Maps Berlin",
        description: nil,
        dateTime: firstOfApril,
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
      )
    ]
    let service = NextRideService(nextRide: { _, _, _ in
      Just(rides)
        .setFailureType(to: NextRideService.Failure.self)
        .eraseToAnyPublisher()
    })
    var settings: UserDefaultsClient = .noop
    settings.dataForKey = { _ in
      try? RideEventSettings.default
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
    store.send(.getNextRide(coordinate))
    store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = rides.sortByDateAndFilterBeforeDate(store.environment.now)
    }
    store.receive(.setNextRide(rides[0])) {
      $0.nextRide = rides[0]
    }
  }

  func test_getNextRide_returnRideFromThisMonth_whenTodayIsSaturday() {
    let rides = [
      Ride(
        id: 0,
        slug: nil,
        title: "CriticalMaps Berlin",
        description: nil,
        dateTime: now().addingTimeInterval(60 * 60 * 24).addingTimeInterval(3600),
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
        title: "Critical Maps Berlin",
        description: nil,
        dateTime: firstOfApril,
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
      )
    ]
    let service = NextRideService(nextRide: { _, _, _ in
      Just(rides)
        .setFailureType(to: NextRideService.Failure.self)
        .eraseToAnyPublisher()
    })
    var settings: UserDefaultsClient = .noop
    settings.dataForKey = { _ in
      try? RideEventSettings.default
        .encoded()
    }
    // when
    let store = TestStore(
      initialState: NextRideState(),
      reducer: nextRideReducer,
      environment: NextRideEnvironment(
        service: service,
        store: settings,
        now: { self.now().addingTimeInterval(60 * 60 * 24) },
        mainQueue: testScheduler.eraseToAnyScheduler(),
        coordinateObfuscator: .live
      )
    )
    // then
    store.send(.getNextRide(coordinate))
    store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = rides.sortByDateAndFilterBeforeDate(store.environment.now)
    }
    store.receive(.setNextRide(rides[0])) {
      $0.nextRide = rides[0]
    }
  }

  func test_getNextRide_returnRideFromThisMonth_whenTodayIsSunday() {
    let rides = [
      Ride(
        id: 0,
        slug: nil,
        title: "CriticalMaps Berlin",
        description: nil,
        dateTime: now().addingTimeInterval(60 * 60 * 48).addingTimeInterval(3600),
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
        title: "Critical Maps Berlin",
        description: nil,
        dateTime: firstOfApril,
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
      )
    ]
    let service = NextRideService(nextRide: { _, _, _ in
      Just(rides)
        .setFailureType(to: NextRideService.Failure.self)
        .eraseToAnyPublisher()
    })
    var settings: UserDefaultsClient = .noop
    settings.dataForKey = { _ in
      try? RideEventSettings.default
        .encoded()
    }
    // when
    let store = TestStore(
      initialState: NextRideState(),
      reducer: nextRideReducer,
      environment: NextRideEnvironment(
        service: service,
        store: settings,
        now: { self.now().addingTimeInterval(60 * 60 * 48) },
        mainQueue: testScheduler.eraseToAnyScheduler(),
        coordinateObfuscator: .live
      )
    )
    // then
    store.send(.getNextRide(coordinate))
    store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = rides.sortByDateAndFilterBeforeDate(store.environment.now)
    }
    store.receive(.setNextRide(rides[0])) {
      $0.nextRide = rides[0]
    }
  }
  
  func test_getNextRide_returnRideFromNextMonth_whenNextWeekendIsInNextMonth() {
    let rides = [
      Ride(
        id: 0,
        slug: nil,
        title: "CriticalMaps Berlin",
        description: nil,
        dateTime: now().addingTimeInterval(60 * 60 * 48).addingTimeInterval(3600),
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
        title: "Critical Maps Berlin",
        description: nil,
        dateTime: firstOfApril,
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
      )
    ]
    let service = NextRideService(nextRide: { _, _, _ in
      Just(rides)
        .setFailureType(to: NextRideService.Failure.self)
        .eraseToAnyPublisher()
    })
    var settings: UserDefaultsClient = .noop
    settings.dataForKey = { _ in
      try? RideEventSettings.default
        .encoded()
    }
    // when
    let store = TestStore(
      initialState: NextRideState(),
      reducer: nextRideReducer,
      environment: NextRideEnvironment(
        service: service,
        store: settings,
        now: { self.now().addingTimeInterval(60 * 60 * 72) }, // Mon. 2022-03-28
        mainQueue: testScheduler.eraseToAnyScheduler(),
        coordinateObfuscator: .live
      )
    )
    // then
    store.send(.getNextRide(coordinate))
    store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = rides.sortByDateAndFilterBeforeDate(store.environment.now)
    }
    store.receive(.setNextRide(rides[1])) {
      $0.nextRide = rides[1]
    }
  }
}
