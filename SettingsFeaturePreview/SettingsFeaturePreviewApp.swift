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
            reducer: SettingsFeature()
          )
        )
      }
    }
  }
}
