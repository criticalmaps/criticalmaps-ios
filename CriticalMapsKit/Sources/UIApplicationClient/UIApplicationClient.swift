import Combine
import ComposableArchitecture
import UIKit.UIApplication

/// A client to interact with UIApplication
@DependencyClient
public struct UIApplicationClient: Sendable {
  public var alternateIconNameAsync: @Sendable () async -> String?
  public var open: @Sendable (URL, [UIApplication.OpenExternalURLOptionsKey: Any]) async -> Bool = { _, _ in true }
  public var openSettingsURLString: @Sendable () async -> String = { "" }
  public var setAlternateIconName: @Sendable (String?) async throws -> Void
  public var setUserInterfaceStyle: @Sendable (UIUserInterfaceStyle) async -> Void
  public var supportsAlternateIconsAsync: @Sendable () async -> Bool = { true }
}

public extension DependencyValues {
  var uiApplicationClient: UIApplicationClient {
    get { self[UIApplicationClient.self] }
    set { self[UIApplicationClient.self] = newValue }
  }
}
