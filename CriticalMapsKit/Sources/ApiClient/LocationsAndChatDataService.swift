import Combine
import Foundation
import SharedModels

// Interface
/// A Service to send and fetch locations and chat messages from the Criticl Maps API
public struct LocationsAndChatDataService {
  public var getLocationsAndSendMessages: (SendLocationAndChatMessagesPostBody) -> AnyPublisher<LocationAndChatMessages, NSError>

  public init(
    getLocationsAndSendMessages: @escaping (SendLocationAndChatMessagesPostBody) -> AnyPublisher<LocationAndChatMessages, NSError>
  ) {
    self.getLocationsAndSendMessages = getLocationsAndSendMessages
  }
}

// MARK: Live
public extension LocationsAndChatDataService {
  static func live(
    apiClient: APIClient = .live
  ) -> Self { Self(
    getLocationsAndSendMessages: { body in
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

// MARK: Mocks and failing used for previews and tests
public extension LocationsAndChatDataService {
  static let noop = Self(
    getLocationsAndSendMessages: { _ in
      Just(LocationAndChatMessages(locations: [:], chatMessages: [:]))
        .setFailureType(to: NSError.self)
        .eraseToAnyPublisher()
    }
  )
  
  static let failing = Self(
    getLocationsAndSendMessages: { _ in
      Fail(error: NSError(domain: "", code: 1))
        .eraseToAnyPublisher()
    }
  )
}
