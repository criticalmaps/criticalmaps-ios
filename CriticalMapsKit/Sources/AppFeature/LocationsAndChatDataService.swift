import ApiClient
import Combine
import Foundation
import SharedModels

// Interface
public struct LocationsAndChatDataService {
  var getLocations: (SendLocationAndChatMessagesPostBody) -> AnyPublisher<LocationAndChatMessages, NSError>
}

// Live implementation
public extension LocationsAndChatDataService {
  static func live(
    apiClient: APIClient = .live
  ) -> Self { Self(
    getLocations: { body in
      let request = PostLocationAndChatMessagesRequest(body: try? body.encoded())
      
      return apiClient.dispatch(request)
        .decode(
          type: PostLocationAndChatMessagesRequest.ResponseDataType.self,
          decoder: request.decoder
        )
        .mapError { $0 as NSError }
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
        .setFailureType(to: NSError.self)
        .eraseToAnyPublisher()
    }
  )
  
  static let failing = Self(
    getLocations: { _ in
      Fail(error: NSError(domain: "", code: 1))
        .eraseToAnyPublisher()
    }
  )
}
