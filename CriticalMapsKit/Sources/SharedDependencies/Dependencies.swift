import ApiClient
import ComposableArchitecture
import FileClient
import IDProvider
import PathMonitorClient
import SwiftUI
import UIApplicationClient
import UserDefaultsClient

public extension DependencyValues {
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
