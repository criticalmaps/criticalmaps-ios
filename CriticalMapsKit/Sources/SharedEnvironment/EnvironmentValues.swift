import SwiftUI

public extension EnvironmentValues {
  /// Environment key to get the apps connectivity state
  var connectivity: Bool {
    get { self[ConnectionStateKey.self] }
    set { self[ConnectionStateKey.self] = newValue }
  }
}

private struct ConnectionStateKey: EnvironmentKey {
  static var defaultValue: Bool { true }
}
