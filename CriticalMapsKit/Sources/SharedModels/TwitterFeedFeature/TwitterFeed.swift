import Foundation

public struct TwitterFeed: Codable, Hashable {
  public var statuses: [Tweet]

  public init(statuses: [Tweet]) {
    self.statuses = statuses
  }
}

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

public struct TwitterUser: Codable, Hashable {
  public var name: String
  public var screenName: String
  public var profileImageUrl: String
  
  public var profileImage: URL? {
    URL(string: profileImageUrl)
  }
  
  public init(name: String, screenName: String, profileImageUrl: String) {
    self.name = name
    self.screenName = screenName
    self.profileImageUrl = profileImageUrl
  }
  
  private enum CodingKeys: String, CodingKey {
    case name
    case screenName = "screen_name"
    case profileImageUrl = "profile_image_url_https"
  }
}
