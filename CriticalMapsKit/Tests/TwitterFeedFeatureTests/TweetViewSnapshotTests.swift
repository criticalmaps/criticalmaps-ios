import SharedModels
import TestHelper
import TwitterFeedFeature
import XCTest

class TweetViewSnapshotTests: XCTestCase {
  func test_tweetViewSnapshot() {
    let view = TweetView(
      tweet: Tweet(
        id: "19283123120381203",
        text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore",
        createdAt: .init(timeIntervalSinceNow: 0),
        user: .init(
          name: "Critical Maps",
          screenName: "@maps",
          profileImageUrl: ""
        )
      )
    )
      .padding(.horizontal, 8)

    assertScreenSnapshot(view)
  }
  
  func test_tweetViewSnapshot_redacted() {
    let view = TweetView(
      tweet: Tweet(
        id: "19283123120381203",
        text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore",
        createdAt: .init(timeIntervalSinceNow: 0),
        user: .init(
          name: "Critical Maps",
          screenName: "@maps",
          profileImageUrl: ""
        )
      )
    )
    .redacted(reason: .placeholder)
    .padding(.horizontal, 8)

    assertScreenSnapshot(view)
  }
}
