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

extension TootService: DependencyKey {
  public static let liveValue: TootService = Self(
    getToots: {
      let client = MastodonKit.Client(baseURL: "https://mastodon.social")
      let request = Timelines.tag("CriticalMass")
      let statuses = try await client.run(request).value
      return statuses
    }
  )
}

// Mocks and failing used for previews and tests
extension TootService: TestDependencyKey {
  public static let previewValue = Self(
    getToots: { [] }
  )

  public static let testValue = Self()
}

extension DependencyValues {
  var tootService: TootService {
    get { self[TootService.self] }
    set { self[TootService.self] = newValue }
  }
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
