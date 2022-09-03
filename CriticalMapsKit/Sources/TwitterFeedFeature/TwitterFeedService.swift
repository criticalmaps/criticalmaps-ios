import ApiClient
import Foundation
import SharedModels

// MARK: Interface

/// Service to fetch tweets from `api.criticalmaps.net/twitter`
public struct TwitterFeedService {
  public var getTweets: () async throws -> [Tweet]
}

// MARK: Live

public extension TwitterFeedService {
  static func live(apiClient: APIClient = .live) -> Self {
    Self(
      getTweets: {
        let request = TwitterFeedRequest()
        
        let tweetData = try await apiClient.dispatch(request)
        let tweets = try request.decode(tweetData)
        return tweets.statuses
      }
    )
  }
}

// Mocks and failing used for previews and tests
public extension TwitterFeedService {
  static let noop = Self(
    getTweets: { return [] }
  )

  static let failing = Self(
    getTweets: { throw NSError(domain: "", code: 1) }
  )
}
