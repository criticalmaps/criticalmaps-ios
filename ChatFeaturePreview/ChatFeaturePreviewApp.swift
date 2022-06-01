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
            reducer: chatReducer,
            environment: .init(
              locationsAndChatDataService: .live(),
              mainQueue: .main,
              idProvider: .live(),
              uuid: UUID.init,
              date: Date.init,
              userDefaultsClient: .live()
            )
          )
        )
      }
    }
  }
}
