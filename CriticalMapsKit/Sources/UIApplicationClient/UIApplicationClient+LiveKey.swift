import Combine
import ComposableArchitecture
import Foundation
import OSLog
import UIKit.UIApplication

extension UIApplicationClient: DependencyKey {
  public static let liveValue = Self(
    alternateIconName: { UIApplication.shared.alternateIconName },
    alternateIconNameAsync: { await UIApplication.shared.alternateIconName },
    open: { @MainActor in await UIApplication.shared.open($0, options: $1) },
    openSettingsURLString: { UIApplication.openSettingsURLString },
    setAlternateIconName: { @MainActor in
      // Set the icon name to nil to use the primary icon.
      let iconName: String? = ($0 != "appIcon-2") ? $0 : nil
      // Avoid setting the name if the app already uses that icon.
      guard UIApplication.shared.alternateIconName != iconName else {
        Logger.client.debug("IconName already set")
        return
      }
      
      try await UIApplication.shared.setAlternateIconName(iconName)
    },
    setUserInterfaceStyle: { @MainActor in
      UIApplication.shared.firstWindowSceneWindow?.overrideUserInterfaceStyle = $0
    },
    supportsAlternateIcons: { UIApplication.shared.supportsAlternateIcons },
    supportsAlternateIconsAsync: { await UIApplication.shared.supportsAlternateIcons }
  )
}

private extension UIApplication {
  var firstWindowSceneWindow: UIWindow? {
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    return windowScene?.windows.first
  }
}

private extension Logger {
  private static var subsystem = "UIApplicationClient"
  static let client = Logger(
    subsystem: subsystem,
    category: "LiveKey"
  )
}
