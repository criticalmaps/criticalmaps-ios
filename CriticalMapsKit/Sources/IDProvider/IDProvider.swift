import ComposableArchitecture
import CryptoKit
import Foundation
import Helpers

/// Provides a hashed ID to create api update requests
@DependencyClient
public struct IDProvider: Sendable {
  public var id: @Sendable () -> String = { "" }
  public var token: @Sendable () -> String = { "" }

  public static func hash(id: String, currentDate: () -> Date) -> String {
    let dateString = DateFormatter.IDStoreHashDateFormatter.string(from: currentDate())
    let input = String(id + dateString).data(using: .utf8)!
    let hash = SHA512.hash(data: input)
    return hash.map { String(format: "%02hhx", $0) }.joined()
  }
}
