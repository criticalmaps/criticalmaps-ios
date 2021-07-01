//
//  File.swift
//  
//
//  Created by Malte on 08.06.21.
//

import ApiClient
import Combine
import CoreLocation
import Foundation
import SharedModels

public struct NextRideService {
  var nextRide: (
    _ coordinate: Coordinate,
    _ eventSearchRadius: Int
  )
  -> AnyPublisher<[Ride], Failure>
}

public extension NextRideService {
  static func live(
    apiClient: APIClient = .live
  ) -> Self { Self(
    nextRide: { coordinate, radius in
      let request = NextRidesRequest(coordinate: coordinate, radius: radius)
      return apiClient.dispatch(request)
        .decode(type: NextRidesRequest.ResponseDataType.self, decoder: request.decoder)
        .mapError { Failure(internalError: $0 as! NetworkRequestError) }
        .eraseToAnyPublisher()
    }
  )
  }
  
  static let noop = Self(
    nextRide: { _, _ in
      Just([])
        .setFailureType(to: NextRideService.Failure.self)
        .eraseToAnyPublisher()
    }
  )
  
  struct Failure: Error, Equatable {
    var internalError: NetworkRequestError
  }
}
