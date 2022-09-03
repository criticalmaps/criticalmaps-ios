import Foundation
import Network

public extension PathMonitorClient {
  static let satisfied = Self {
    AsyncStream { continuation in
      continuation.yield(NetworkPath(status: .satisfied))
      continuation.finish()
    }
  }

  static let unsatisfied = Self {
    AsyncStream { continuation in
      continuation.yield(NetworkPath(status: .unsatisfied))
      continuation.finish()
    }
  }
}
