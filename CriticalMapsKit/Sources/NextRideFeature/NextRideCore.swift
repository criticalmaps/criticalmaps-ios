//
//  File.swift
//  
//
//  Created by Malte on 11.06.21.
//

import Combine
import ComposableArchitecture
import Foundation
import Logger
import SharedModels
import UserDefaultsClient

public struct NextRideState: Equatable {
  public var nextRide: Ride?
}

public enum NextRideAction: Equatable {
  case getNextRide(Coordinate)
  case nextRideResponse(Result<[Ride], NextRideService.Failure>)
  case onAppear
}

public struct NextRideEnvironment {
  let service: NextRideService
  let store: UserDefaultsClient
  let now: () -> Date
  let defaultSearchRadius = 10
  let mainQueue: DispatchQueue
}

public let nextRideReducer = Reducer<NextRideState, NextRideAction, NextRideEnvironment> { state, action, env in
  switch action {
  case .onAppear:
    // get coordinate
    // obfuscate
    // return Effect
    return Effect(value: .getNextRide(Coordinate(latitude: 53.12, longitude: 13.13)))
  case .getNextRide(let coordinate):
    guard let settings = env.store.rideEventSettings, settings.isEnabled else {
      return .none
    }
    return env.service.nextRide(coordinate, env.store.rideEventSettings?.radiusSettings.radius ?? env.defaultSearchRadius)
      .receive(on: env.mainQueue)
      .catchToEffect()
      .map(NextRideAction.nextRideResponse)
  case let .nextRideResponse(.failure(error)):
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
      .filter { $0.enabled }
      .sorted(by: \.dateTime)
      .first { ride in ride.dateTime > env.now() }
    
    guard let ride = ride else {
      Logger.logger.info("No upcoming events")
      return .none
    }
    
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
