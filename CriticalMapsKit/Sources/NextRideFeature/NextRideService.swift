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
        .mapError { Failure(internalError: $0) }
        .eraseToAnyPublisher()
    }
  )
  }
  
  struct Failure: Error, Equatable {
    var internalError: NetworkRequestError
  }
}
