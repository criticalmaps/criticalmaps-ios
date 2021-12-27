import Foundation

/// A structure to represent a twitter user.
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
