import ComposableArchitecture
import UIKit.UIApplication

public struct UIApplicationClient {
  public var open: (URL, [UIApplication.OpenExternalURLOptionsKey: Any]) -> Effect<Bool, Never>
  public var openSettingsURLString: () -> String
  
  public init(
    open: @escaping (URL, [UIApplication.OpenExternalURLOptionsKey : Any]) -> Effect<Bool, Never>,
    openSettingsURLString: @escaping () -> String
  ) {
    self.open = open
    self.openSettingsURLString = openSettingsURLString
  }
}

public extension UIApplicationClient {
  static let live = Self(
    open: { url, options in
        .future { callback in
          UIApplication.shared.open(url, options: options) { bool in
            callback(.success(bool))
          }
        }
    },
    openSettingsURLString: { UIApplication.openSettingsURLString }
  )
  
  static let noop = Self(
    open: { _, _ in .none },
    openSettingsURLString: { "" }
  )
}
