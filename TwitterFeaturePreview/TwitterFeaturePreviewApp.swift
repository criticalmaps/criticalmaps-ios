import ComposableArchitecture
import SwiftUI
import TwitterFeedFeature

@main
struct TwitterFeaturePreviewApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        TwitterFeedView(
          store: .init(
            initialState: .init(),
            reducer: twitterFeedReducer,
            environment: .init(
              service: .live(),
              mainQueue: .main,
              uiApplicationClient: .live
            )
          )
        )
        .navigationTitle("TwitterFeature Preview")
      }
      .navigationBarTitleDisplayMode(.inline)
      
    }
  }
}
