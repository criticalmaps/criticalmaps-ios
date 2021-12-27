import Foundation

/// A structure to wrap the API response chat message dictionary and make it renderable in a SwiftUI List.
public struct IdentifiedChatMessage: Equatable, Identifiable {
  public let id: String
  public let message: String
  public let timestamp: TimeInterval
  
  public init(
    id: String,
    message: String,
    timestamp: TimeInterval
  ) {
    self.id = id
    self.message = message
    self.timestamp = timestamp
  }
  
  /// Localized representation of the chat messages timestamp 
  public var chatTime: String {
    let date = Date(timeIntervalSince1970: timestamp)
    return DateFormatter.chatMessageViewFormatter().string(from: date)
  }
}
