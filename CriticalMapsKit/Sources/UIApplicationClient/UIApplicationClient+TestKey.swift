import Combine
import ComposableArchitecture
import Foundation
import UIKit.UIApplication

extension UIApplicationClient: TestDependencyKey {
  public static let testValue = Self()
  public static let previewValue: UIApplicationClient = Self(
    alternateIconNameAsync: { nil },
    open: { _, _ in false },
    openSettingsURLString: { "settings://criticalmaps/settings" },
    setAlternateIconName: { _ in },
    setUserInterfaceStyle: { _ in },
    supportsAlternateIconsAsync: { true }
  )
}
