import Combine
import ComposableArchitecture
import UIKit.UIApplication

/// A client to interact with UIApplication
@DependencyClient
public struct UIApplicationClient {
  public var alternateIconName: () -> String?
  public var alternateIconNameAsync: @Sendable () async -> String?
  public var open: @Sendable (URL, [UIApplication.OpenExternalURLOptionsKey: Any]) async -> Bool = { _, _ in true }
  public var openSettingsURLString: @Sendable () async -> String = { "" }
  public var setAlternateIconName: @Sendable (String?) async throws -> Void
  @available(*, deprecated)
  public var supportsAlternateIcons: () -> Bool = { true }
  public var supportsAlternateIconsAsync: @Sendable () async -> Bool = { true }
}

public extension DependencyValues {
  var uiApplicationClient: UIApplicationClient {
    get { self[UIApplicationClient.self] }
    set { self[UIApplicationClient.self] = newValue }
  }
}
