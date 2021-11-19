import CryptoKit
import Foundation
import Helpers

/// Provides a hashed ID to create api update requests
public struct IDProvider {
  public var id: () -> String
  public var token: () -> String
  
  public static func hash(id: String, currentDate: Date = Date()) -> String {
    let dateString = DateFormatter.IDStoreHashDateFormatter.string(from: currentDate)
    let input = String(id + dateString).data(using: .utf8)!
    let hash = SHA512.hash(data: input)
    return hash.map { String(format: "%02hhx", $0) }.joined()
  }
}
