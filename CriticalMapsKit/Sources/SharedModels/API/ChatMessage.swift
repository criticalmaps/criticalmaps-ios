import Foundation

public struct ChatMessage: Codable, Hashable {
  var message: String
  var timestamp: TimeInterval
  
  var decodedMessage: String? {
    message
      .replacingOccurrences(of: "+", with: " ")
      .removingPercentEncoding
  }
}
