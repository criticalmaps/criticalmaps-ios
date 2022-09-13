import ComposableArchitecture
import SwiftUI
import UIApplicationClient
import UserDefaultsClient

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


public extension DependencyValues {
  var uiApplicationClient: UIApplicationClient {
    get { self[UIApplicationClientKey.self] }
    set { self[UIApplicationClientKey.self] = newValue }
  }
  
  var userDefaultsClient: UserDefaultsClient {
    get { self[UserDefaultsClientKey.self] }
    set { self[UserDefaultsClientKey.self] = newValue }
  }
}


// MARK: Keys


private enum UserDefaultsClientKey: TestDependencyKey {
  static let liveValue = UserDefaultsClient.live()
  static let testValue = UserDefaultsClient.noop
}

private enum UIApplicationClientKey: TestDependencyKey {
  static let liveValue = UIApplicationClient.live
  static let testValue = UIApplicationClient.noop
}
