import Foundation

public struct LocationAndChatMessages: Codable, Hashable {
  public init(
    locations: [String : Location],
    chatMessages: [String : ChatMessage]
  ) {
    self.locations = locations
    self.chatMessages = chatMessages
  }
  
  public let locations: [String: Location]
  public let chatMessages: [String: ChatMessage]
  
  /// Maped from parameter locations to be able to use bindings
  public var riders: [Rider] {
    locations.map { Rider(id: $0.key, location: $0.value) }
  }
}
