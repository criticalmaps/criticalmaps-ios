import ApiClient
import CoreLocation
import Foundation
import SharedModels

// MARK: Interface

/// Service to fetch the next ride and decode the response
public struct NextRideService {
  public var nextRide: (
    _ coordinate: Coordinate,
    _ eventSearchRadius: Int,
    _ month: Int
  ) async throws -> [Ride]
}

// MARK: Live

public extension NextRideService {
  static func live(apiClient: APIClient = .live()) -> Self {
    Self { coordinate, radius, month in
      let request = NextRidesRequest(coordinate: coordinate, radius: radius, month: month)
      let (data, _) = try await apiClient.request(request)
      let rides = try request.decode(data)
      return rides
    }
  }
}

// MARK: Mocks

public extension NextRideService {
  static let noop = Self(
    nextRide: { _, _, _ in [] }
  )

  struct Failure: Error, Equatable {
    var internalError: NetworkRequestError
  }
}
