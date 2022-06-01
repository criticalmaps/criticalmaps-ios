import ApiClient
import Combine
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
  ) -> AnyPublisher<[Ride], Failure>
}

// MARK: Live

public extension NextRideService {
  static func live(
    apiClient: APIClient = .live
  ) -> Self { Self(
    nextRide: { coordinate, radius, month in
      let request = NextRidesRequest(coordinate: coordinate, radius: radius, month: month)
      return apiClient.dispatch(request)
        .decode(type: NextRidesRequest.ResponseDataType.self, decoder: request.decoder)
        .mapError { Failure(internalError: $0 as! NetworkRequestError) }
        .eraseToAnyPublisher()
    }
  )
  }
}

// MARK: Mocks

public extension NextRideService {
  static let noop = Self(
    nextRide: { _, _, _ in
      Just([])
        .setFailureType(to: NextRideService.Failure.self)
        .eraseToAnyPublisher()
    }
  )

  struct Failure: Error, Equatable {
    var internalError: NetworkRequestError
  }
}
