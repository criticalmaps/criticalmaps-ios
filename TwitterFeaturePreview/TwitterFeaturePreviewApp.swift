import ComposableArchitecture
import TwitterFeedFeature
import SwiftUI

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
