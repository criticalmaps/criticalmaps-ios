import Foundation

public struct Tweet: Codable, Hashable, Identifiable {
  public var id: String
  public var text: String
  public var createdAt: Date
  public var user: TwitterUser
  
  public var tweetUrl: URL? {
    URL(string: "https://twitter.com/\(user.screenName)/status/\(id)")
  }
  
  public init(id: String, text: String, createdAt: Date, user: TwitterUser) {
    self.id = id
    self.text = text
    self.createdAt = createdAt
    self.user = user
  }
  
  private enum CodingKeys: String, CodingKey {
    case text
    case createdAt = "created_at"
    case user
    case id = "id_str"
  }
}
