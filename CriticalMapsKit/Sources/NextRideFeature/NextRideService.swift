import ApiClient
import ComposableArchitecture
import CoreLocation
import Foundation
import SharedModels

// MARK: Interface

/// Service to fetch the next ride and decode the response
@DependencyClient
public struct NextRideService {
  public var nextRide: (
    _ coordinate: Coordinate,
    _ eventSearchRadius: Int,
    _ month: Int
  ) async throws -> [Ride]
}

// MARK: Live

extension NextRideService: DependencyKey {
  public static var liveValue: Self {
    @Dependency(\.apiClient) var apiClient

    return Self { coordinate, radius, month in
      let request = Request.nextRides(coordinate: coordinate, radius: radius, month: month)
      let (data, _) = try await apiClient.send(request)
      let rides: [Ride] = try data.decoded(decoder: .nextRideRequestDecoder)
      return rides
    }
  }
}

// MARK: Mocks

extension NextRideService: TestDependencyKey {
  public static let previewValue: NextRideService = Self(
    nextRide: { _, _, _ in [] }
  )

  public static let testValue: NextRideService = Self()

  public struct Failure: Error {
    public var internalError: NetworkRequestError

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
