import Foundation

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
  
  var chatTime: String {
    let date = Date(timeIntervalSince1970: timestamp)
    return DateFormatter.chatMessageViewFormatter().string(from: date)
  }
}
