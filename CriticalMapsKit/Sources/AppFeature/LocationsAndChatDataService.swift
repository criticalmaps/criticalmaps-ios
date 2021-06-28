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

// Interface
public struct LocationsAndChatDataService {
  var getLocations: (SendLocationAndChatMessagesPostBody) -> AnyPublisher<LocationAndChatMessages, Failure>
  
  public struct Failure: Error, Equatable {
    var internalError: NetworkRequestError
  }
}

// Live implementation
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
}
 
// Mocks and failing used for previews and tests
public extension LocationsAndChatDataService {
  static let noop = Self(
    getLocations: { _ in
      Just(LocationAndChatMessages(locations: [:], chatMessages: [:]))
        .setFailureType(to: Failure.self)
        .eraseToAnyPublisher()
    }
  )
  
  static let failing = Self(
    getLocations: { _ in
      Fail(error: Failure(internalError: .serverError))
        .eraseToAnyPublisher()
    }
  )
}
