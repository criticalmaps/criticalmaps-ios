import Combine
import ComposableArchitecture
import CoreLocation
import Foundation
import Logger
import SharedModels
import UserDefaultsClient

// MARK: State
public struct NextRideState: Equatable {
  public init(nextRide: Ride? = nil, hasConnectivity: Bool = true) {
    self.nextRide = nextRide
    self.hasConnectivity = hasConnectivity
  }
  
  public var hasConnectivity: Bool
  public var nextRide: Ride?
}


// MARK: Actions
public enum NextRideAction: Equatable {
  case getNextRide(Coordinate)
  case nextRideResponse(Result<[Ride], NextRideService.Failure>)
  case setNextRide(Ride)
}


// MARK: Environment
public struct NextRideEnvironment {
  public init(
    service: NextRideService = .live(),
    store: UserDefaultsClient = .live(),
    now: @escaping () -> Date = Date.init,
    mainQueue: AnySchedulerOf<DispatchQueue>,
    coordinateObfuscator: CoordinateObfuscator = .live
  ) {
    self.service = service
    self.userDefaultsClient = store
    self.now = now
    self.mainQueue = mainQueue
    self.coordinateObfuscator = coordinateObfuscator
  }
  
  let service: NextRideService
  let userDefaultsClient: UserDefaultsClient
  let now: () -> Date
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let coordinateObfuscator: CoordinateObfuscator
}


// MARK: Reducer
/// Reducer handling next ride feature actions
public let nextRideReducer = Reducer<NextRideState, NextRideAction, NextRideEnvironment> { state, action, env in
  switch action {
  case .getNextRide(let coordinate):
    guard env.userDefaultsClient.rideEventSettings().isEnabled else {
      logger.debug("NextRide featue is disabled")
      return .none
    }
    guard state.hasConnectivity else {
      logger.debug("Not fetching next ride. No connectivity")
      return .none
    }
    
    let obfuscatedCoordinate = env.coordinateObfuscator.obfuscate(
      coordinate,
      .thirdDecimal
    )
    
    let requestRidesInMonth: Int = queryMonth(in: env.now)
    
    return env.service.nextRide(
      obfuscatedCoordinate,
      env.userDefaultsClient.rideEventSettings().eventDistance.rawValue,
      requestRidesInMonth
    )
      .receive(on: env.mainQueue)
      .catchToEffect()
      .map(NextRideAction.nextRideResponse)
    
  case let .nextRideResponse(.failure(error)):
    logger.error("Get next ride failed 🛑 with error: \(error)")
    return .none
  case let .nextRideResponse(.success(rides)):
    guard !rides.isEmpty else {
      logger.info("Rides array is empty")
      return .none
    }
    guard !rides.map(\.rideType).isEmpty else {
      logger.info("No upcoming events for filter selection rideType")
      return .none
    }
    // Sort rides by date and pick the first one with a date greater than now
    let ride = rides // swiftlint:disable:this sorted_first_last
      .lazy
      .filter {
        guard let type = $0.rideType else { return true }
        return env.userDefaultsClient.rideEventSettings().typeSettings
          .lazy
          .filter(\.isEnabled)
          .map(\.type)
          .contains(type)
      }
      .filter(\.enabled)
      .sorted(by: \.dateTime)
      .first(where: { ride in ride.dateTime > env.now() })
    
    guard let filteredRide = ride else {
      logger.info("No upcoming events after filter")
      return .none
    }
    
    return Effect(value: .setNextRide(filteredRide))
    
  case let .setNextRide(ride):
    state.nextRide = ride
    return .none
  }
}

enum EventError: Error, LocalizedError {
  case eventsAreNotEnabled
  case invalidDateError
  case rideIsOutOfRangeError
  case noUpcomingRides
  case rideTypeIsFiltered
  case rideDisabled
}


private func queryMonth(in date: () -> Date = Date.init, calendar: Calendar = .current) -> Int {
  let currentMonthOfFallback = calendar.dateComponents([.month], from: date()).month ?? 0
  
  guard !calendar.isDateInWeekend(date()) else { // current date is on a weekend
    return currentMonthOfFallback
  }
  
  guard let startDateOfNextWeekend = calendar.nextWeekend(startingAfter: date())?.start else {
    return currentMonthOfFallback
  }
  guard let month = calendar.dateComponents([.month], from: startDateOfNextWeekend).month else {
    return currentMonthOfFallback
  }
  
  return max(currentMonthOfFallback, month)
}
