import SharedModels
import TestHelper
import TwitterFeedFeature
import XCTest

class TweetListViewSnapshotTests: XCTestCase {
  func test_tweetListViewSnapshot() {
    let view = TweetListView(
      store: .init(
        initialState: .init(contentState: .results(.placeHolder)),
        reducer: twitterFeedReducer,
        environment: TwitterFeedEnvironment(
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tweetListViewSnapshot_dark() {
    let view = TweetListView(
      store: .init(
        initialState: .init(contentState: .results(.placeHolder)),
        reducer: twitterFeedReducer,
        environment: TwitterFeedEnvironment(
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
      .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tweetListViewSnapshot_redacted() {
    let view = TweetListView(
      store: .init(
        initialState: .init(contentState: .results(.placeHolder)),
        reducer: twitterFeedReducer,
        environment: TwitterFeedEnvironment(
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    .redacted(reason: .placeholder)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tweetListViewSnapshot_redacted_dark() {
    let view = TweetListView(
      store: .init(
        initialState: .init(contentState: .results(.placeHolder)),
        reducer: twitterFeedReducer,
        environment: TwitterFeedEnvironment(
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    .redacted(reason: .placeholder)
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tweetListViewSnapshot_empty() {
    let view = TweetListView(
      store: .init(
        initialState: .init(contentState: .empty(.twitter)),
        reducer: twitterFeedReducer,
        environment: TwitterFeedEnvironment(
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    
    assertScreenSnapshot(view)
  }
  
  func test_tweetListViewSnapshot_empty_dark() {
    let view = TweetListView(
      store: .init(
        initialState: .init(contentState: .empty(.twitter)),
        reducer: twitterFeedReducer,
        environment: TwitterFeedEnvironment(
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view)
  }
  
  func test_tweetListViewSnapshot_error() {
    let view = TweetListView(
      store: .init(
        initialState: .init(contentState: .error(.default)),
        reducer: twitterFeedReducer,
        environment: TwitterFeedEnvironment(
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    
    assertScreenSnapshot(view)
  }
  
  func test_tweetListViewSnapshot_error_dark() {
    let view = TweetListView(
      store: .init(
        initialState: .init(contentState: .error(.default)),
        reducer: twitterFeedReducer,
        environment: TwitterFeedEnvironment(
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view)
  }
}
