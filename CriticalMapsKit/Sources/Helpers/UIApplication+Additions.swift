import UIKit.UIApplication

public extension UIApplication {
  var firstWindowSceneWindow: UIWindow? {
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    return windowScene?.windows.first
  }
}
