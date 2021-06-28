import AppFeature
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    let appView = AppView(
      store: .init(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
          service: .live(),
          idProvider: .live(),
          mainQueue: .main
        )
      )
    )
    
    self.window = (scene as? UIWindowScene).map(UIWindow.init(windowScene:))
    self.window?.rootViewController = UIHostingController(rootView: appView)
    self.window?.makeKeyAndVisible()
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {    
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    true
  }
}
