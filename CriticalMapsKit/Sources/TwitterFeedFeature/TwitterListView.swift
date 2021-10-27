import ComposableArchitecture
import Foundation
import Styleguide
import SwiftUI
import SharedModels

public struct TweetListView: View {
  let store: Store<TwitterFeedState, TwitterFeedAction>
  @ObservedObject var viewStore: ViewStore<TwitterFeedState, TwitterFeedAction>
  
  public init(store: Store<TwitterFeedState, TwitterFeedAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  public var body: some View {
    List(viewStore.tweets) { tweet in
      TweetView(tweet: tweet)
        .onTapGesture {
          viewStore.send(.openTweet(tweet))
        }
    }
    .listStyle(InsetListStyle())
  }
}

// MARK: Preview
struct TweetListView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TweetListView(
        store: Store<TwitterFeedState, TwitterFeedAction>(
          initialState: TwitterFeedState(tweets: .placeHolder),
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
