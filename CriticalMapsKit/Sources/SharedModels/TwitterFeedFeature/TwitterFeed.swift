import Foundation

public struct TwitterFeed: Codable, Hashable {
  public var statuses: [Tweet]

  public init(statuses: [Tweet]) {
    self.statuses = statuses
  }
}

public struct Tweet: Codable, Hashable, Identifiable {
  public var id: Int
  public var text: String
  public var createdAt: Date
  public var user: TwitterUser
  
  public init(id: Int, text: String, createdAt: Date, user: TwitterUser) {
    self.id = id
    self.text = text
    self.createdAt = createdAt
    self.user = user
  }
}

public struct TwitterUser: Codable, Hashable {
  var name: String
  var screenName: String
  var profileImageUrlHttps: String
  
  public init(name: String, screenName: String, profileImageUrlHttps: String) {
    self.name = name
    self.screenName = screenName
    self.profileImageUrlHttps = profileImageUrlHttps
  }
}
