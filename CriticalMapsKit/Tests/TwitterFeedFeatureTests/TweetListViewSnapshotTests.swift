import SharedModels
import TestHelper
import TwitterFeedFeature
import XCTest

class TweetListViewSnapshotTests: XCTestCase {
  func test_tweetListViewSnapshot() {
    let view = TweetListView(
      store: .init(
        initialState: .init(tweets: [Tweet].placeHolder),
        reducer: twitterFeedReducer,
        environment: TwitterFeedEnvironment(
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    
    assertScreenSnapshot(view)
  }
  
  func test_tweetListViewSnapshot_redacted() {
    let view = TweetListView(
      store: .init(
        initialState: .init(tweets: [Tweet].placeHolder),
        reducer: twitterFeedReducer,
        environment: TwitterFeedEnvironment(
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    .redacted(reason: .placeholder)
    
    assertScreenSnapshot(view)
  }
}
