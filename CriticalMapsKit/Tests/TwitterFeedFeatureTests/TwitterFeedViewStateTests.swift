import Foundation
import TwitterFeedFeature
import XCTest

class TwitterFeedViewStateTests: XCTestCase {
  func test_setShouldDisplayPlaceholder() {
    var feedState = TwitterFeedState(contentState: .loading([]))
    feedState.twitterFeedIsLoading = true
    
    let viewState = TwitterFeedView.TwitterFeedViewState(feedState)
    XCTAssertTrue(viewState.shouldDisplayPlaceholder)
  }
  
  func test_setShouldDisplayPlaceholder2() {
    var feedState = TwitterFeedState(
      contentState: .results([
        .init(
          id: "1",
          text: "",
          createdAt: .distantFuture,
          user: .init(
            name: "TwitterBiker",
            screenName: "🐥",
            profileImageUrl: ""
          )
        )
      ])
    )
    feedState.twitterFeedIsLoading = false
    
    let viewState = TwitterFeedView.TwitterFeedViewState(feedState)
    XCTAssertFalse(viewState.shouldDisplayPlaceholder)
  }
}
