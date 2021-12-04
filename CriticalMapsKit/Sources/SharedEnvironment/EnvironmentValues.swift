import SwiftUI

extension EnvironmentValues {
  public var connectivity: Bool {
    get { self[ConnectionStateKey.self] }
    set { self[ConnectionStateKey.self] = newValue }
  }
}

private struct ConnectionStateKey: EnvironmentKey {
  static var defaultValue: Bool { true }
}
