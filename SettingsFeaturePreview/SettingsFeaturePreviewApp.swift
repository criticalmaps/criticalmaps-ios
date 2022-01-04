import SettingsFeature
import SwiftUI
import UIKit.UIApplication

@main
struct SettingsFeaturePreviewApp: App {
    var body: some Scene {
        WindowGroup {
          NavigationView {
            SettingsView(
              store: .init(
                initialState: .init(),
                reducer: settingsReducer,
                environment: .init(
                  uiApplicationClient: .live,
                  setUserInterfaceStyle: { userInterfaceStyle in
                    .fireAndForget {
                      UIApplication.shared.firstWindowSceneWindow?.overrideUserInterfaceStyle = userInterfaceStyle
                    }
                  },
                  fileClient: .live,
                  backgroundQueue: DispatchQueue(label: "settingsFeaturePreview").eraseToAnyScheduler(),
                  mainQueue: .main
                )
              )
            )
          }
        }
    }
}
