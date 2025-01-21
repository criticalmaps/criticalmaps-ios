import ComposableArchitecture
import Foundation
import Network

extension PathMonitorClient: TestDependencyKey {
  public static var testValue: PathMonitorClient = Self()

  public static let satisfied = Self {
    AsyncStream { continuation in
      continuation.yield(NetworkPath(status: .satisfied))
      continuation.finish()
    }
  }

  public static let unsatisfied = Self {
    AsyncStream { continuation in
      continuation.yield(NetworkPath(status: .unsatisfied))
      continuation.finish()
    }
  }
}
