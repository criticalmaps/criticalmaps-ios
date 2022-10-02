import ComposableArchitecture
import CustomDump
import Foundation
import SharedModels
import TwitterFeedFeature
import XCTest

@MainActor
final class TweetTests: XCTestCase {
  
  func test_createdAt_dateformatting() {
    let date = Date(timeIntervalSince1970: 1635521516)
    
    let tweet = Tweet(
      id: "ID",
      text: "TEXT T$ESXT",
      createdAt: date,
      user: .init(
        name: "M",
        screenName: "mbnz",
        profileImageUrl: ""
      )
    )
    
    let currentDate = date.advanced(by: 3600)
    
    let (value, a11yValue) = tweet.formattedCreationDate(currentDate: { currentDate })
    XCTAssertNoDifference(value, "1 hr")
    XCTAssertNoDifference(a11yValue, "1 hour ago")
  }
  
  func test_createdAt_dateformatting2() {
    let date = Date(timeIntervalSince1970: 1635262316)
    
    let tweet = Tweet(
      id: "ID",
      text: "TEXT T$ESXT",
      createdAt: date.advanced(by: -232000),
      user: .init(
        name: "M",
        screenName: "mbnz",
        profileImageUrl: ""
      )
    )

    let (value, a11yValue) = tweet.formattedCreationDate(currentDate: { date })
    XCTAssertNoDifference(value, "24. Oct")
    XCTAssertNoDifference(a11yValue, "2 days ago")
  }
  
  func test_openTweetUrl() async throws {
    let date = Date(timeIntervalSince1970: 1635521516)
    
    let openedUrl = ActorIsolated<URL?>(nil)
        
    let tweet = Tweet(
      id: "ID",
      text: "TEXT T$ESXT",
      createdAt: date,
      user: .init(
        name: "M",
        screenName: "mbnz",
        profileImageUrl: ""
      )
    )
    let store = TestStore(
      initialState: tweet,
      reducer: TweetFeature()
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      await openedUrl.setValue(url)
      return true
    }
    await store.send(.openTweet)
    
    await openedUrl.withValue({ url in
      XCTAssertEqual(url, tweet.tweetUrl)
    })
  }
}
