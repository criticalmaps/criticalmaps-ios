import ApiClient
import ComposableArchitecture
import FileClient
import IDProvider
import PathMonitorClient
import SwiftUI
import UIApplicationClient
import UserDefaultsClient

public extension DependencyValues {
  var isNetworkAvailable: Bool {
    get { self[ConnectionStateKey.self] }
    set {
       _isNetworkAvailable = newValue
      self[ConnectionStateKey.self] = newValue
    }
  }
  
  var setUserInterfaceStyle: SetUserInterfaceStyleEffect {
    get { self[SetUserInterfaceStyleKey.self] }
    set { self[SetUserInterfaceStyleKey.self] = newValue }
  }
}


// MARK: Keys

public typealias SetUserInterfaceStyleEffect = @Sendable (UIUserInterfaceStyle) async -> Void
enum SetUserInterfaceStyleKey: DependencyKey {
  
  static let liveValue: SetUserInterfaceStyleEffect = { userInterfaceStyle in
    await MainActor.run {
      UIApplication.shared.firstWindowSceneWindow?.overrideUserInterfaceStyle = userInterfaceStyle
    }
  }
  static let testValue: SetUserInterfaceStyleEffect = { _ in () }
}

enum ConnectionStateKey: DependencyKey {
  static var liveValue = _isNetworkAvailable
  static var testValue = false
}

// swiftlint:disable:next identifier_name
public var _isNetworkAvailable = true
