import Foundation

/// A structure that represents the API response from api.criticalmaps.net/twitter
public struct TwitterFeed: Codable, Hashable {
  public var statuses: [Tweet]

  public init(statuses: [Tweet]) {
    self.statuses = statuses
  }
}
