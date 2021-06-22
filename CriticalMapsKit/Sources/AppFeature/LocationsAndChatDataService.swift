//
//  File.swift
//  
//
//  Created by Malte on 15.06.21.
//

import ApiClient
import Combine
import Foundation
import SharedModels

public struct LocationsAndChatDataService {
  var getLocations: (SendLocationAndChatMessagesPostBody) -> AnyPublisher<LocationAndChatMessages, Failure>
}

public extension LocationsAndChatDataService {
  static func live(
    apiClient: APIClient = .live
  ) -> Self { Self(
    getLocations: { body in
      let request = PostLocationAndChatMessagesRequest(body: try? body.encoded())
      
      return apiClient.dispatch(request)
        .mapError { Failure(internalError: $0) }
        .eraseToAnyPublisher()
    }
  )
  }
  
  static let noop = Self(
    getLocations: { _ in
      Empty(outputType: LocationAndChatMessages.self, failureType: Failure.self)
        .eraseToAnyPublisher()
    }
  )
  
  struct Failure: Error, Equatable {
    var internalError: NetworkRequestError
  }
}
