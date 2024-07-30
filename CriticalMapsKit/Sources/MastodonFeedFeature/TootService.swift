import ApiClient
import ComposableArchitecture
import Foundation
import MastodonKit
import SharedModels

// MARK: Interface

@DependencyClient
public struct TootService {
  public var getToots: () async throws -> [MastodonKit.Status]
}

// MARK: Live

public extension TootService {
  static func live() -> Self {
    Self(
      getToots: {
        let client = MastodonKit.Client(baseURL: "https://mastodon.social")
        let request = Timelines.tag("CriticalMass")
        let statuses = try await client.run(request).value
        return statuses
      }
    )
  }
}

// Mocks and failing used for previews and tests
public extension TootService {
  static let noop = Self(
    getToots: { [] }
  )

  static let failing = Self(
    getToots: { throw NSError(domain: "", code: 1) }
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
