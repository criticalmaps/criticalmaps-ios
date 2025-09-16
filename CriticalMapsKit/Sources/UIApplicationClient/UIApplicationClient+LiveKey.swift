import Combine
import ComposableArchitecture
import Foundation
import UIKit.UIApplication

extension UIApplicationClient: DependencyKey {
  public static let liveValue = Self(
    alternateIconName: { UIApplication.shared.alternateIconName },
    alternateIconNameAsync: { await UIApplication.shared.alternateIconName },
    open: { @MainActor in await UIApplication.shared.open($0, options: $1) },
    openSettingsURLString: { UIApplication.openSettingsURLString },
    setAlternateIconName: { @MainActor in
      try await UIApplication.shared.setAlternateIconName($0)
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
