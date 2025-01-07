import AppFeature
import ComposableArchitecture
import SwiftUI

@main
struct CriticalMapsApp: App {  
  @MainActor
  static let store = Store(initialState: AppFeature.State()) {
    AppFeature()
      ._printChanges()
  }

  var body: some Scene {
    WindowGroup {
      AppView(store: Self.store)
    }
  }
}
