import Combine
import ComposableArchitecture
import Foundation
import Helpers
import NextRideFeature
import SharedModels
import UserDefaultsClient
import XCTest

final class NextRideCoreTests: XCTestCase {
  let now = {
    Calendar.current.date(
      from: .init(
        timeZone: .germany,
        year: 2022,
        month: 3,
        day: 25,
        hour: 12
      )
    )!
  }

  let testScheduler = DispatchQueue.immediate
  
  var berlin: Ride {
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
    )
  }
  
  var berlinNow: Ride {
    Ride(
      id: 0,
      slug: nil,
      title: "CriticalMaps Berlin",
      description: nil,
      dateTime: now(),
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
  }
  
  var falkensee: Ride {
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
  }
  
  var rides: [Ride] { [berlin, falkensee] }
  let coordinate = Coordinate(latitude: 53.1234, longitude: 13.4233)
  
  @MainActor
  func test_disabledNextRideFeature_shouldNotRequestRides() async {
    let store = TestStore(
      initialState: .init(),
      reducer: { NextRideFeature() }
    ) {
      $0.nextRideService.nextRide = { _, _, _ in [] }
      $0.date = .init({ @Sendable in self.now() })
      $0.userDefaultsClient.dataForKey = { _ in
        try? RideEventSettings(
          isEnabled: false,
          typeSettings: [:],
          eventDistance: .near
        )
        .encoded()
      }
    }
    
    // no effect received
    await store.send(.getNextRide(coordinate))
    await store.receive(.nextRideResponse(.success([])))
  }
  
  @MainActor
  func test_getRides_shouldUpdateRidesInUserTimezone() async {
    let store = TestStore(
      initialState: .init(),
      reducer: { NextRideFeature() }
    )
    store.dependencies.userDefaultsClient.dataForKey = { _ in try? RideEventSettings.default.encoded()
    }
    store.dependencies.nextRideService.nextRide = { _, _, _ in self.rides }
    store.dependencies.date = .constant(now())
    store.dependencies.isNetworkAvailable = true
    
    // then
    await _ = store.send(.getNextRide(coordinate))
    await store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = self.rides.sortByDateAndFilterBeforeDate(store.dependencies.date.callAsFunction)
    }
    await store.receive(.setNextRide(rides[1])) {
      $0.nextRide = self.rides[1]
    }
  }
  
  @MainActor
  func test_getNextRide_shouldReturnError() async {
    let store = TestStore(
      initialState: .init(),
      reducer: { NextRideFeature() }
    )
    store.dependencies.userDefaultsClient.dataForKey = { _ in
      try? RideEventSettings(
        isEnabled: true,
        typeSettings: [:],
        eventDistance: .near
      )
      .encoded()
    }
    store.dependencies.isNetworkAvailable = true
    store.dependencies.nextRideService.nextRide = { _, _, _ in
      throw NextRideService.Failure(internalError: .badRequest)
    }
    store.dependencies.date = .constant(now())
    
    // then
    _ = await store.send(.getNextRide(coordinate))
    await store.receive(.nextRideResponse(.failure(NextRideService.Failure(internalError: .badRequest))))
  }
  
  @MainActor
  func test_getNextRide_shouldNotSetRide_whenRideTypeIsNotEnabled() async {
    let store = TestStore(
      initialState: .init(),
      reducer: { NextRideFeature() }
    )
    store.dependencies.nextRideService.nextRide = { _, _, _ in
      self.rides
    }
    store.dependencies.isNetworkAvailable = true
    store.dependencies.userDefaultsClient.dataForKey = { _ in
      try? RideEventSettings(
        isEnabled: true,
        typeSettings: [.kidicalMass: true],
        eventDistance: .near
      )
      .encoded()
    }
    store.dependencies.date = .constant(now())
    
    // then
    _ = await store.send(.getNextRide(coordinate))
    await store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = [self.falkensee, self.berlin]
    }
    await store.receive(.setNextRide(rides.last!)) {
      $0.nextRide = self.falkensee
    }
  }

  @MainActor
  func test_getNextRide_shouldReturnRide_whenRideTypeNil() async {
    let ridesWithARideWithNilRideType: [Ride] = [
      Ride(
        id: 0,
        title: "CriticalMaps Berlin",
        dateTime: now().addingTimeInterval(36000),
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .criticalMass
      ),
      Ride(
        id: 0,
        title: "CriticalMaps Falkensee",
        dateTime: now().addingTimeInterval(3600),
        location: "Vorplatz der alten Stadthalle",
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .alleycat
      )
    ]
   
    // when
    let store = TestStore(
      initialState: .init(),
      reducer: { NextRideFeature() }
    )
    store.dependencies.nextRideService.nextRide = { _, _, _ in
      ridesWithARideWithNilRideType
    }
    store.dependencies.userDefaultsClient.dataForKey = { _ in
      try? RideEventSettings.default.encoded()
    }
    store.dependencies.date = .constant(now())
    store.dependencies.isNetworkAvailable = true
    
    // then
    _ = await store.send(.getNextRide(coordinate))
    await store.receive(.nextRideResponse(.success(ridesWithARideWithNilRideType))) {
      $0.rideEvents = ridesWithARideWithNilRideType.sortByDateAndFilterBeforeDate(store.dependencies.date.callAsFunction)
    }
    await store.receive(.setNextRide(ridesWithARideWithNilRideType[1])) {
      $0.nextRide = ridesWithARideWithNilRideType[1]
    }
  }
  
  @MainActor
  func test_getNextRide_shouldNotSetRide_whenRideTypeIsEnabledButRideIsCancelled() async {
    let rides = [
      Ride(
        id: 0,
        title: "CriticalMaps Berlin",
        dateTime: now().addingTimeInterval(3600),
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: false,
        rideType: .criticalMass
      )
    ]
    
    // when
    let store = TestStore(
      initialState: .init(),
      reducer: { NextRideFeature() }
    )
    store.dependencies.nextRideService.nextRide = { _, _, _ in rides }
    store.dependencies.userDefaultsClient.dataForKey = { _ in
      try? RideEventSettings.default
        .encoded()
    }
    store.dependencies.date = .constant(now())
    store.dependencies.isNetworkAvailable = true
    
    // then
    _ = await store.send(.getNextRide(coordinate))
    await store.receive(.nextRideResponse(.success(rides))) {
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
  
  @MainActor
  func test_getNextRide_returnRideFromThisMonth_whenTodayIsFriday() async {
    let rides = [
      Ride(
        id: 0,
        title: "CriticalMaps Berlin",
        dateTime: now().addingTimeInterval(3600),
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .criticalMass
      ),
      Ride(
        id: 0,
        title: "Critical Maps Berlin",
        dateTime: firstOfApril,
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .criticalMass
      )
    ]
    
    // when
    let store = TestStore(
      initialState: .init(),
      reducer: { NextRideFeature() }
    )
    store.dependencies.userDefaultsClient.dataForKey = { _ in
      try? RideEventSettings.default
        .encoded()
    }
    store.dependencies.nextRideService.nextRide = { _, _, _ in rides }
    store.dependencies.date = .constant(now())
    store.dependencies.isNetworkAvailable = true
    
    // then
    _ = await store.send(.getNextRide(coordinate))
    await store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = rides.sortByDateAndFilterBeforeDate(store.dependencies.date.callAsFunction)
    }
    await store.receive(.setNextRide(rides[0])) {
      $0.nextRide = rides[0]
    }
  }
  
  @MainActor
  func test_getNextRide_returnRideFromThisMonth_whenTwoRidesHaveTheSameDate() async {
    let rides = [
      Ride(
        id: 0,
        title: "CriticalMaps Berlin",
        dateTime: firstOfApril.addingTimeInterval(74000),
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .criticalMass
      ),
      Ride(
        id: 7,
        title: "Critical Maps Berlin",
        dateTime: firstOfApril,
        latitude: 63.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .criticalMass
      ),
      Ride(
        id: 4,
        title: "Critical Maps Pankow",
        dateTime: firstOfApril,
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .criticalMass
      )
    ]
    
    // when
    var state = NextRideFeature.State()
    state.userLocation = .init(latitude: 53.1235, longitude: 13.4248)
    let store = TestStore(
      initialState: state,
      reducer: { NextRideFeature() }
    )
    store.dependencies.nextRideService.nextRide = { _, _, _ in rides }
    store.dependencies.userDefaultsClient.dataForKey = { _ in
      try? RideEventSettings.default
        .encoded()
    }
    store.dependencies.date = .constant(now())
    store.dependencies.calendar = .autoupdatingCurrent
    store.dependencies.isNetworkAvailable = true
    
    // then
    _ = await store.send(.getNextRide(coordinate))
    await store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = rides.sortByDateAndFilterBeforeDate(store.dependencies.date.callAsFunction)
    }
    await store.receive(.setNextRide(rides[2])) {
      $0.nextRide = rides[2]
    }
  }

  @MainActor
  func test_getNextRide_returnRideFromThisMonth_whenTodayIsSaturday() async {
    let rides = [
      Ride(
        id: 0,
        title: "CriticalMaps Berlin",
        dateTime: now().addingTimeInterval(60 * 60 * 24).addingTimeInterval(3600),
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .criticalMass
      ),
      Ride(
        id: 0,
        title: "Critical Maps Berlin",
        dateTime: firstOfApril,
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .criticalMass
      )
    ]
    
    // when
    let store = TestStore(
      initialState: .init(),
      reducer: { NextRideFeature() }
    )
    store.dependencies.nextRideService.nextRide = { _, _, _ in rides }
    store.dependencies.userDefaultsClient.dataForKey = { _ in
      try? RideEventSettings.default
        .encoded()
    }
    store.dependencies.date = .constant(now())
    store.dependencies.isNetworkAvailable = true
    
    // then
    _ = await store.send(.getNextRide(coordinate))
    await store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = rides.sortByDateAndFilterBeforeDate(store.dependencies.date.callAsFunction)
    }
    await store.receive(.setNextRide(rides[0])) {
      $0.nextRide = rides[0]
    }
  }

  @MainActor
  func test_getNextRide_returnRideFromThisMonth_whenTodayIsSunday() async {
    let rides = [
      Ride(
        id: 0,
        title: "CriticalMaps Berlin",
        dateTime: now().addingTimeInterval(60 * 60 * 48).addingTimeInterval(3600),
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .criticalMass
      ),
      Ride(
        id: 0,
        title: "Critical Maps Berlin",
        dateTime: firstOfApril,
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .criticalMass
      )
    ]
    
    // when
    let store = TestStore(
      initialState: .init(),
      reducer: { NextRideFeature() }
    )
    store.dependencies.nextRideService.nextRide = { _, _, _ in rides }
    store.dependencies.userDefaultsClient.dataForKey = { _ in
      try? RideEventSettings.default
        .encoded()
    }
    store.dependencies.date = .constant(now())
    store.dependencies.isNetworkAvailable = true
    
    // then
    _ = await store.send(.getNextRide(coordinate))
    await store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = rides.sortByDateAndFilterBeforeDate(store.dependencies.date.callAsFunction)
    }
    await store.receive(.setNextRide(rides[0])) {
      $0.nextRide = rides[0]
    }
  }
  
  @MainActor
  func test_getNextRide_returnRideFromNextMonth_whenNextWeekendIsInNextMonth() async {
    let rides = [
      Ride(
        id: 0,
        title: "CriticalMaps Berlin",
        dateTime: now().addingTimeInterval(60 * 60 * 48).addingTimeInterval(3600),
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .criticalMass
      ),
      Ride(
        id: 0,
        title: "Critical Maps Berlin",
        dateTime: firstOfApril,
        latitude: 53.1235,
        longitude: 13.4234,
        enabled: true,
        rideType: .criticalMass
      )
    ]
    
    // when
    let store = TestStore(
      initialState: .init(),
      reducer: { NextRideFeature() }
    )
    store.dependencies.nextRideService.nextRide = { _, _, _ in rides }
    store.dependencies.userDefaultsClient.dataForKey = { _ in
      try? RideEventSettings.default
        .encoded()
    }
    store.dependencies.date = .constant(now().addingTimeInterval(60 * 60 * 72))
    store.dependencies.isNetworkAvailable = true
    
    // then
    _ = await store.send(.getNextRide(coordinate))
    await store.receive(.nextRideResponse(.success(rides))) {
      $0.rideEvents = rides.sortByDateAndFilterBeforeDate(store.dependencies.date.callAsFunction)
    }
    await store.receive(.setNextRide(rides[1])) {
      $0.nextRide = rides[1]
    }
  }
}
