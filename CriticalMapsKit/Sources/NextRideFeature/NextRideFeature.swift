import Combine
import ComposableArchitecture
import ComposableCoreLocation
import Foundation
import os
import SharedKeys
import SharedModels

// MARK: State

@Reducer
public struct NextRideFeature: Sendable {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public init(nextRide: Ride? = nil) {
      self.nextRide = nextRide
    }

    public var nextRide: Ride?
    public var rideEvents: [Ride] = []

    @Shared(.userSettings) var userSettings
    @Shared(.rideEventSettings) var rideEventSettings

    public var userLocation: Coordinate?
  }

  // MARK: Actions

  public enum Action {
    case getNextRide(Coordinate)
    case nextRideResponse(Result<[Ride], any Error>)
    case setNextRide(Ride)
  }

  // MARK: Reducer

  @Dependency(\.nextRideService) private var service
  @Dependency(\.date) private var date
  @Dependency(\.coordinateObfuscator) private var coordinateObfuscator
  @Dependency(\.calendar) private var calendar

  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case let .getNextRide(coordinate):
      guard state.rideEventSettings.isEnabled else {
        Logger.reducer.debug("NextRide feature is disabled")
        return .none
      }

      let obfuscatedCoordinate = coordinateObfuscator.obfuscate(
        coordinate,
        .thirdDecimal
      )

      let requestRidesInMonth: Int = queryMonth(for: date.callAsFunction)

      return .run { [distance = state.rideEventSettings.eventDistance] send in
        await send(
          .nextRideResponse(
            Result {
              try await service.nextRide(
                obfuscatedCoordinate,
                distance.rawValue,
                requestRidesInMonth
              )
            }
          )
        )
      }

    case let .nextRideResponse(.failure(error)):
      Logger.reducer.error("Get next ride failed 🛑 with error: \(error)")
      return .none

    case let .nextRideResponse(.success(rides)):
      guard !rides.isEmpty else {
        Logger.reducer.debug("Rides array is empty")
        return .none
      }
      guard !rides.map(\.rideType).isEmpty else {
        Logger.reducer.info("No upcoming events for filter selection rideType")
        return .none
      }
      let typeSettings = state.rideEventSettings.rideEvents
      state.rideEvents = rides.sortByDateAndFilterBeforeDate(date.callAsFunction)

      // Sort rides by date and pick the first one with a date greater than now
      let ride = rides
        .lazy
        .filter {
          guard let type = $0.rideType else { return true }
          return typeSettings.contains(where: { $0.rideType == type })
        }
        .filter(\.enabled)
        .sorted { lhs, rhs in
          let byDate = lhs.dateTime < rhs.dateTime

          guard
            let userLocation = state.userLocation,
            let lhsCoordinate = lhs.coordinate,
            let rhsCoordinate = rhs.coordinate
          else {
            return byDate
          }

          if calendar.isDate(lhs.dateTime, inSameDayAs: rhs.dateTime) {
            return lhsCoordinate.distance(from: userLocation) < rhsCoordinate.distance(from: userLocation)
          } else {
            return byDate
          }
        }
        .first { ride in ride.dateTime > date() }

      guard let filteredRide = ride else {
        Logger.reducer.info("No upcoming events after filter")
        return .none
      }
      return .run { send in
        await send(.setNextRide(filteredRide))
      }

    case let .setNextRide(ride):
      state.nextRide = ride
      return .none
    }
  }
}

// MARK: Helper

enum EventError: Error, LocalizedError {
  case eventsAreNotEnabled
  case invalidDateError
  case rideIsOutOfRangeError
  case noUpcomingRides
  case rideTypeIsFiltered
  case rideDisabled
}

func queryMonth(for date: () -> Date = Date.init, calendar: Calendar = .current) -> Int {
  let today = date()
  let currentMonth = calendar.dateComponents([.month], from: today).month ?? 0
  let currentYear = calendar.dateComponents([.year], from: today).year ?? 0

  // Find the last Friday of the current month
  // Critical Mass rides happen on the last Friday of each month
  guard let lastFriday = findLastFriday(in: currentMonth, year: currentYear, calendar: calendar) else {
    return currentMonth
  }

  // If today is on or before the last Friday of the month, query current month
  // If today is after the last Friday, query next month
  if calendar.isDate(today, inSameDayAs: lastFriday) || today < lastFriday {
    return currentMonth
  } else {
    // Move to next month (handles year boundary)
    let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: today) ?? today
    return calendar.dateComponents([.month], from: nextMonthDate).month ?? currentMonth
  }
}

/// Finds the last Friday of a given month and year
private func findLastFriday(in month: Int, year: Int, calendar: Calendar) -> Date? {
  let dateComponents = DateComponents(year: year, month: month)
  guard let firstDay = calendar.date(from: dateComponents) else { return nil }
  guard let range = calendar.range(of: .day, in: .month, for: firstDay) else { return nil }

  // Find all Fridays in the month and return the last one
  var fridays: [Date] = []
  for day in range {
    if let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) {
      if calendar.component(.weekday, from: date) == 6 { // Friday = 6
        fridays.append(date)
      }
    }
  }
  return fridays.last
}

public extension [Ride] {
  func sortByDateAndFilterBeforeDate(_ now: () -> Date) -> Self {
    lazy
      .sorted(by: \.dateTime)
      .filter { $0.dateTime > now() }
  }
}

extension SharedModels.Coordinate {
  init(_ location: ComposableCoreLocation.Location) {
    self = .init(
      latitude: location.coordinate.latitude,
      longitude: location.coordinate.longitude
    )
  }
}

private extension Logger {
  /// Using your bundle identifier is a great way to ensure a unique identifier.
  private static let subsystem = "NextRideFeature"

  /// Logs the view cycles like a view that appeared.
  static let reducer = Logger(
    subsystem: subsystem,
    category: "Reducer"
  )
}
