import ComposableArchitecture
import Foundation
import L10n
import SharedModels
import Styleguide
import SwiftUI

public struct TweetListView: View {
  let store: Store<TwitterFeedState, TwitterFeedAction>
  @ObservedObject var viewStore: ViewStore<TwitterFeedState, TwitterFeedAction>

  public init(store: Store<TwitterFeedState, TwitterFeedAction>) {
    self.store = store
    viewStore = ViewStore(store)
  }

  public var body: some View {
    Group {
      switch viewStore.contentState {
      case let .empty(state):
        EmptyStateView(
          emptyState: state,
          buttonAction: { viewStore.send(.fetchData) },
          buttonText: L10n.EmptyState.reload
        )
      case let .results(tweets), let .loading(tweets):
        ZStack {
          Color(.backgroundPrimary)
            .ignoresSafeArea()

          List(tweets) { tweet in
            TweetView(tweet: tweet)
              .onTapGesture {
                viewStore.send(.openTweet(tweet))
              }
          }
          .listRowBackground(Color(.backgroundPrimary))
          .listStyle(PlainListStyle())
        }
      case let .error(state):
        ErrorStateView(
          errorState: state,
          buttonAction: { viewStore.send(.fetchData) },
          buttonText: "Reload"
        )
      }
    }
    .refreshable {
      await viewStore.send(.fetchData, while: \.twitterFeedIsLoading)
    }
  }
}

// MARK: Preview

struct TweetListView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TweetListView(
        store: Store<TwitterFeedState, TwitterFeedAction>(
          initialState: TwitterFeedState(contentState: .results(.placeHolder)),
          reducer: twitterFeedReducer,
          environment: TwitterFeedEnvironment(
            service: .noop,
            mainQueue: .failing,
            uiApplicationClient: .noop
          )
        )
      )

      TweetListView(store: .placeholder)
        .redacted(reason: .placeholder)
    }
  }
}

public extension EmptyState {
  static let twitter = Self(
    icon: Asset.twitterEmpty.image,
    text: L10n.Twitter.noData,
    message: NSAttributedString.highlightMentionsAndTags(in: L10n.Twitter.Empty.message)
  )
}
