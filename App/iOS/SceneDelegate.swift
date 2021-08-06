import AppFeature
import ComposableArchitecture
import InfoBar
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private var infobarWindow: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    self.window = (scene as? UIWindowScene).map(UIWindow.init(windowScene:))
    
    let infobarController = InfobarController.live()
    let contentViewController = setupContentViewController(infobarController: infobarController)
    let containerViewController = InfobarContainerViewController(rootViewController: contentViewController)
    
    window.rootViewController = containerViewController
    window.makeKeyAndVisible()
    self.window = window
    
    setupInfobarWindow(
      windowScene: windowScene,
      infobarController: infobarController
    )
  }
  
  private func setupInfobarWindow(
    windowScene: UIWindowScene,
    infobarController: InfobarController
  ) {
    let infobarWindow = InfobarOverlayWindow(
      windowScene: windowScene,
      infobarController: infobarController
    )
    
    self.infobarWindow = infobarWindow
  }
  
  private func setupContentViewController(infobarController: InfobarController) -> UIViewController {
    let appStore = Store<AppState, AppAction>(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        service: .live(),
        idProvider: .live(),
        mainQueue: .main,
        infoBannerPresenter: infobarController
      )
    )
    let appView = AppView(store: appStore)
    return UIHostingController(rootView: appView)
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

extension View {
  func inHostingViewControllerWithExtendedSafeArea() -> some View {
    modifier(ExtendedSafeAreaModifier())
  }
}

struct ExtendedSafeAreaModifier: ViewModifier {
  
  func body(content: Content) -> some View {
    Container(content: content)
      .edgesIgnoringSafeArea(.all)
  }
  
  private struct Container: UIViewRepresentable {
    let content: Content
    
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIViewType {
      let hostingController = UIHostingController(rootView: content)
      hostingController.additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: 200, right: 0)
      context.coordinator.container = hostingController
      return hostingController.view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
      uiView.setNeedsLayout()
    }
    
    func makeCoordinator() -> Coordinator {
      .init()
    }
    
    class Coordinator {
      var container: UIViewController!
    }
  }
}
