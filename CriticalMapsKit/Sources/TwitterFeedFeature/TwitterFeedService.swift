import ApiClient
import Combine
import Foundation
import SharedModels

// Interface
public struct TwitterFeedService {
  var getTwitterFeed: () -> AnyPublisher<[Tweet], NSError>
}


// Live implementation
public extension TwitterFeedService {
  static func live(apiClient: APIClient = .live) -> Self {
    Self(
      getTwitterFeed: {
        let request = TwitterFeedRequest()
        
        return apiClient.dispatch(request)
          .decode(
            type: TwitterFeedRequest.ResponseDataType.self,
            decoder: request.decoder
          )
          .map(\.statuses)
          .mapError { $0 as NSError }
          .eraseToAnyPublisher()
      }
    )
  }
}


// Mocks and failing used for previews and tests
public extension TwitterFeedService {
  static let noop = Self(
    getTwitterFeed: {
      Just([])
        .setFailureType(to: NSError.self)
        .eraseToAnyPublisher()
    }
  )
  
  static let failing = Self(
    getTwitterFeed: {
      Fail(error: NSError(domain: "", code: 1))
        .eraseToAnyPublisher()
    }
  )
}
