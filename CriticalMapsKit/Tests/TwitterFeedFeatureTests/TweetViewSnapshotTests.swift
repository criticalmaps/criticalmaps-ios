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

    assertScreenSnapshot(view)
  }
  
  func test_tweetViewSnapshot_dark() {
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
    .environment(\.colorScheme, .dark)

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

    assertScreenSnapshot(view)
  }
  
  func test_tweetViewSnapshot_redacted_dark() {
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
    .environment(\.colorScheme, .dark)
    .redacted(reason: .placeholder)

    assertScreenSnapshot(view)
  }
}