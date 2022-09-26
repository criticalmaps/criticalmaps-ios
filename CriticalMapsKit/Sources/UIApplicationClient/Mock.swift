import ComposableArchitecture
import Foundation

public extension UIApplicationClient {
  static let noop = Self(
    alternateIconName: { nil },
    alternateIconNameAsync: { nil },
    open: { _, _ in false },
    openSettingsURLString: { "settings://criticalmaps/settings" },
    setAlternateIconName: { _ in },
    supportsAlternateIcons: { true },
    supportsAlternateIconsAsync: { true }
  )
}
