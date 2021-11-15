import Foundation

public struct ChatMessage: Codable, Hashable {
  let id = UUID()
  
  public var message: String
  public var timestamp: TimeInterval
  
  public init(message: String, timestamp: TimeInterval) {
    self.message = message
    self.timestamp = timestamp
  }
    
  public var decodedMessage: String? {
    message
      .replacingOccurrences(of: "+", with: " ")
      .removingPercentEncoding
  }
  
  private enum CodingKeys: String, CodingKey { case message, timestamp }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
