import Foundation

/// A structure that represents new chat message post
public struct ChatMessagePost: Codable, Hashable {
  public var text: String
  public var timestamp: TimeInterval
  public var identifier: String

  public init(text: String, timestamp: TimeInterval, identifier: String) {
    self.text = text
    self.timestamp = timestamp
    self.identifier = identifier
  }
}
