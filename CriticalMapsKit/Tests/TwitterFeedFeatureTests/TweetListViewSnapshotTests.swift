import SharedModels
import SnapshotTesting
import TestHelper
import TwitterFeedFeature
import XCTest

class TweetListViewSnapshotTests: XCTestCase {
  override func setUpWithError() throws {
    try super.setUpWithError()
//      isRecording = true
  }
    
  func test_tweetListViewSnapshot() {
    let view = TweetListView(
      store: .init(
        initialState: .init(contentState: .results(.placeHolder)),
        reducer: TwitterFeedFeature.reducer,
        environment: TwitterFeedFeature.Environment(
          service: .noop,
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
        reducer: TwitterFeedFeature.reducer,
        environment: TwitterFeedFeature.Environment(
          service: .noop,
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
        reducer: TwitterFeedFeature.reducer,
        environment: TwitterFeedFeature.Environment(
          service: .noop,
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
        reducer: TwitterFeedFeature.reducer,
        environment: TwitterFeedFeature.Environment(
          service: .noop,
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
        reducer: TwitterFeedFeature.reducer,
        environment: TwitterFeedFeature.Environment(
          service: .noop,
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tweetListViewSnapshot_empty_dark() {
    let view = TweetListView(
      store: .init(
        initialState: .init(contentState: .empty(.twitter)),
        reducer: TwitterFeedFeature.reducer,
        environment: TwitterFeedFeature.Environment(
          service: .noop,
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tweetListViewSnapshot_error() {
    let view = TweetListView(
      store: .init(
        initialState: .init(contentState: .error(.default)),
        reducer: TwitterFeedFeature.reducer,
        environment: TwitterFeedFeature.Environment(
          service: .noop,
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tweetListViewSnapshot_error_dark() {
    let view = TweetListView(
      store: .init(
        initialState: .init(contentState: .error(.default)),
        reducer: TwitterFeedFeature.reducer,
        environment: TwitterFeedFeature.Environment(
          service: .noop,
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
}
