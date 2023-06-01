import Foundation

/// A structire that represents a chat message. On create it creates a unique id for itself.
public struct ChatMessage: Codable, Hashable, Identifiable {
  public var id: String { identifier }
  
  public let identifier: String
  public let device: String
  public var message: String
  public var timestamp: TimeInterval
  
  public init(
    identifier: String,
    device: String,
    message: String,
    timestamp: TimeInterval
  ) {
    self.identifier = identifier
    self.device = device
    self.message = message
    self.timestamp = timestamp
  }
  
  public var decodedMessage: String? {
    message
      .replacingOccurrences(of: "+", with: " ")
      .removingPercentEncoding
  }
    
  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
    hasher.combine(device)
    hasher.combine(message)
  }
}
