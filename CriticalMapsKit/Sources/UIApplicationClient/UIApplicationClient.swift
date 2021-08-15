import Combine
import ComposableArchitecture
import UIKit.UIApplication

public struct UIApplicationClient {
  public var alternateIconName: () -> String?
  public var open: (URL, [UIApplication.OpenExternalURLOptionsKey: Any]) -> Effect<Bool, Never>
  public var openSettingsURLString: () -> String
  public var setAlternateIconName: (String?) -> Effect<Never, Error>
  public var supportsAlternateIcons: () -> Bool
}

public extension UIApplicationClient {
  static let live = Self(
    alternateIconName: { UIApplication.shared.alternateIconName },
    open: { url, options in
        .future { callback in
          UIApplication.shared.open(url, options: options) { bool in
            callback(.success(bool))
          }
        }
    },
    openSettingsURLString: { UIApplication.openSettingsURLString },
    setAlternateIconName: { iconName in
      .run { subscriber in
        UIApplication.shared.setAlternateIconName(iconName) { error in
          if let error = error {
            subscriber.send(completion: .failure(error))
          } else {
            subscriber.send(completion: .finished)
          }
        }
        return AnyCancellable {}
      }
    },
    supportsAlternateIcons: { UIApplication.shared.supportsAlternateIcons }
  )
  
  static let noop = Self(
    alternateIconName: { "" },
    open: { _, _ in .none },
    openSettingsURLString: { "settings://criticalmaps/settings" },
    setAlternateIconName: { _ in .none },
    supportsAlternateIcons: { true }
  )
}
