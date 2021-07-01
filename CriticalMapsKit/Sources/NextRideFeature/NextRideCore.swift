//
//  File.swift
//  
//
//  Created by Malte on 11.06.21.
//

import Combine
import ComposableArchitecture
import CoreLocation
import Foundation
import Logger
import SharedModels
import UserDefaultsClient

public struct NextRideState: Equatable {
  public init(nextRide: Ride? = nil) {
    self.nextRide = nextRide
  }
  
  public var nextRide: Ride?
}

public enum NextRideAction: Equatable {
  case getNextRide(Coordinate)
  case nextRideResponse(Result<[Ride], NextRideService.Failure>)
  case setNextRide(Ride)
}

public struct NextRideEnvironment {
  public init(
    service: NextRideService = .live(),
    store: UserDefaultsClient = .live(),
    now: @escaping () -> Date = Date.init,
    mainQueue: AnySchedulerOf<DispatchQueue>,
    coordinateObfuscator: CoordinateObfuscator = .live
  ) {
    self.service = service
    self.store = store
    self.now = now
    self.mainQueue = mainQueue
    self.coordinateObfuscator = coordinateObfuscator
  }
  
  let service: NextRideService
  let store: UserDefaultsClient
  let now: () -> Date
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let coordinateObfuscator: CoordinateObfuscator
}

public let nextRideReducer = Reducer<NextRideState, NextRideAction, NextRideEnvironment> { state, action, env in
  switch action {
  case .getNextRide(let coordinate):
    guard env.store.rideEventSettings().isEnabled else {
      return .none
    }
    let obfuscatedCoordinate = env.coordinateObfuscator.obfuscate(
      coordinate,
      .thirdDecimal
    )
    return env.service.nextRide(
      obfuscatedCoordinate,
      env.store.rideEventSettings().radiusSettings.radius
    )
    .receive(on: env.mainQueue)
    .catchToEffect()
    .map(NextRideAction.nextRideResponse)
  case let .nextRideResponse(.failure(error)):
    Logger.logger.error("Get next ride failed 🛑 with error: \(error)")
    return .none
  case let .nextRideResponse(.success(rides)):
    guard !rides.isEmpty else {
      Logger.logger.info("Rides array is empty")
      return .none
    }
    guard !rides.map(\.rideType).isEmpty else {
      Logger.logger.info("No upcoming events for filter selection rideType")
      return .none
    }
    // Sort rides by date and pick the first one with a date greater than now
    let ride = rides
      .lazy
      .filter {
        guard let type = $0.rideType else { return true }
        return env.store
          .rideEventSettings()
          .typeSettings
          .filter { $0.isEnabled }
          .map(\.type)
          .contains(type)
      }
      .filter { ride in ride.enabled }
      .sorted(by: \.dateTime)
      .first { ride in ride.dateTime > env.now() }
        
    guard let filteredRide = ride else {
      Logger.logger.info("No upcoming events")
      return .none
    }
    
    return Effect(value: .setNextRide(filteredRide))
    
  case let .setNextRide(ride):
    state.nextRide = ride
    return .none
  }
}

public enum EventError: Error, LocalizedError {
  case eventsAreNotEnabled
  case invalidDateError
  case rideIsOutOfRangeError
  case noUpcomingRides
  case rideTypeIsFiltered
  case rideDisabled
}
