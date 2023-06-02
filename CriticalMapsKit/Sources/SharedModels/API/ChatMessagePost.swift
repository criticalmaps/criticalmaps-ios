import Foundation

/// A structure that represents new chat message post
public struct ChatMessagePost: Codable, Hashable {
  public var text: String
  public var device: String
  public var identifier: String

  public init(text: String, device: String, identifier: String) {
    self.text = text
    self.device = device
    self.identifier = identifier
  }
}
