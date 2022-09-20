import ComposableArchitecture
import Foundation
import SharedModels
import Styleguide
import SwiftUI

public struct TwitterFeedView: View {
  public struct TwitterFeedViewState: Equatable {
    public let shouldDisplayPlaceholder: Bool

    public init(_ state: TwitterFeedFeature.State) {
      if let tweets = state.contentState.elements {
        shouldDisplayPlaceholder = state.twitterFeedIsLoading && tweets.isEmpty
      } else {
        shouldDisplayPlaceholder = state.twitterFeedIsLoading
      }
    }
  }

  let store: Store<TwitterFeedFeature.State, TwitterFeedFeature.Action>
  @ObservedObject var viewStore: ViewStore<TwitterFeedViewState, TwitterFeedFeature.Action>

  public init(store: Store<TwitterFeedFeature.State, TwitterFeedFeature.Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: TwitterFeedViewState.init))
  }

  public var body: some View {
    TweetListView(store: viewStore.shouldDisplayPlaceholder ? .placeholder : self.store)
      .navigationBarTitleDisplayMode(.inline)
      .redacted(reason: viewStore.shouldDisplayPlaceholder ? .placeholder : [])
      .onAppear { viewStore.send(.onAppear) }
  }
}

// MARK: Preview

struct TwitterFeedView_Previews: PreviewProvider {
  static var previews: some View {
    TwitterFeedView(
      store: Store<TwitterFeedFeature.State, TwitterFeedFeature.Action>(
        initialState: .init(),
        reducer: TwitterFeedFeature().debug()
      )
    )
  }
}

public extension Array where Element == Tweet {
  static let placeHolder: Self = [0, 1, 2, 3, 4].map {
    Tweet(
      id: String($0),
      text: String("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed invidunt ut labore et dolore".dropLast($0)),
      createdAt: .init(timeIntervalSince1970: TimeInterval(1635521516)),
      user: .init(
        name: "Critical Maps",
        screenName: "@maps",
        profileImageUrl: ""
      )
    )
  }
}

extension Store where State == TwitterFeedFeature.State, Action == TwitterFeedFeature.Action {
  static let placeholder = Store(
    initialState: .init(contentState: .results(.placeHolder)),
    reducer: EmptyReducer()
  )
}
