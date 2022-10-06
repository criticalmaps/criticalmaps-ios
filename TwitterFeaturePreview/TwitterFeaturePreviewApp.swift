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
            reducer: TwitterFeedFeature()
          )
        )
        .navigationTitle("TwitterFeature Preview")
      }
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}
