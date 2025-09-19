import AppFeature
import AppIntentFeature
import ComposableArchitecture
import SwiftUI

@main
struct CriticalMapsApp: App {
  @MainActor
  static let store = Store(initialState: AppFeature.State()) {
    AppFeature()
  }

  var body: some Scene {
    WindowGroup {
      AppView(store: Self.store)
    }
  }

  init() {
    CriticalMapsShortcuts.updateAppShortcutParameters()
  }
}
