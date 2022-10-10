import ComposableArchitecture
import Foundation
import L10n
import SharedModels
import Styleguide
import SwiftUI

public struct TweetListView: View {
  let store: Store<TwitterFeedFeature.State, TwitterFeedFeature.Action>
  @ObservedObject var viewStore: ViewStore<TwitterFeedFeature.State, TwitterFeedFeature.Action>

  public init(store: Store<TwitterFeedFeature.State, TwitterFeedFeature.Action>) {
    self.store = store
    viewStore = ViewStore(store)
  }

  public var body: some View {
    Group {
      if viewStore.tweets.isEmpty {
        EmptyStateView(
          emptyState: .twitter,
          buttonAction: { viewStore.send(.fetchData) },
          buttonText: L10n.EmptyState.reload
        )
      } else if let error = viewStore.error {
        ErrorStateView(
          errorState: error,
          buttonAction: { viewStore.send(.fetchData) },
          buttonText: "Reload"
        )
      } else {
        ZStack {
          Color(.backgroundPrimary)
            .ignoresSafeArea()
          
          List {
            ForEachStore(
              self.store.scope(
                state: \.tweets,
                action: TwitterFeedFeature.Action.tweet(id:action:)
              )
            ) {
              TweetView(store: $0)
            }
          }
          .listRowBackground(Color(.backgroundPrimary))
          .listStyle(PlainListStyle())
        }
      }      
    }
    .refreshable {
      Task {
        await viewStore.send(.refresh, while: \.twitterFeedIsLoading)
      }
    }
  }
}

// MARK: Preview

struct TweetListView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TweetListView(
        store: Store<TwitterFeedFeature.State, TwitterFeedFeature.Action>(
          initialState: .init(tweets: IdentifiedArray(uniqueElements: [Tweet].placeHolder)),
          reducer: TwitterFeedFeature().debug()
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
