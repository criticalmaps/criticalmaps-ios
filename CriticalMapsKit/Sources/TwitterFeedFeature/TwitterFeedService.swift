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
  static func live(apiClient: APIClient = .live()) -> Self {
    Self(
      getTweets: {
        let request: Request = .twitterFeed
        let (data, _) = try await apiClient.send(request)
        let tweets: TwitterFeed = try data.decoded(decoder: .twitterFeedDecoder)
        return tweets.statuses
      }
    )
  }
}

// Mocks and failing used for previews and tests
public extension TwitterFeedService {
  static let noop = Self(
    getTweets: { [] }
  )

  static let failing = Self(
    getTweets: { throw NSError(domain: "", code: 1) }
  )
}

// MARK: Helper

extension DateFormatter {
  static let twitterDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
    return formatter
  }()
}

public extension JSONDecoder {
  static let twitterFeedDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(.twitterDateFormatter)
    return decoder
  }()
}
