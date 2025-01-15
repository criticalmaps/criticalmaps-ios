import ChatFeature
import SwiftUI

@main
struct ChatFeaturePreviewApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ChatView(
          store: .init(
            initialState: .init(),
            reducer: { ChatFeature() }
          )
        )
      }
    }
  }
}
