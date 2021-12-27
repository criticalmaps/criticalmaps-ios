import Combine
import ComposableArchitecture
import UIKit.UIApplication

/// A client to interact with UIApplication
public struct UIApplicationClient {
  public var alternateIconName: () -> String?
  public var open: (URL, [UIApplication.OpenExternalURLOptionsKey: Any]) -> Effect<Bool, Never>
  public var openSettingsURLString: () -> String
  public var setAlternateIconName: (String?) -> Effect<Never, Error>
  public var supportsAlternateIcons: () -> Bool
}
