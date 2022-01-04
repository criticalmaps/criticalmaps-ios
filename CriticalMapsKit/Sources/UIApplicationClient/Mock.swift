import ComposableArchitecture
import Foundation

public extension UIApplicationClient {
  static let noop = Self(
    alternateIconName: { "" },
    open: { _, _ in .none },
    openSettingsURLString: { "settings://criticalmaps/settings" },
    setAlternateIconName: { _ in .none },
    supportsAlternateIcons: { true }
  )
}
