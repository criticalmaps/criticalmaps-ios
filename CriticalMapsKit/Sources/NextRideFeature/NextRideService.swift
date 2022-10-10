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
      let request = Request.nextRides(coordinate: coordinate, radius: radius, month: month)
      let (data, _) = try await apiClient.send(request)
      let rides: [Ride] = try data.decoded(decoder: .nextRideRequestDecoder)
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

    public init(internalError: NetworkRequestError) {
      self.internalError = internalError
    }
  }
}

extension JSONDecoder {
  static let nextRideRequestDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
}
