import Foundation
import XCTest
import SharedModels
import CustomDump

class TweetTests: XCTestCase {
  
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
    XCTAssertNoDifference(tweet.formattedCreationDate(
      currentDate: { currentDate }
    ), "1 hr")
  }
  
  func test_createdAt_dateformatting2() {
    let date = Date(timeIntervalSince1970: 1635262316)
    
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
    let currentDate = date.advanced(by: -232000)
    XCTAssertNoDifference(tweet.formattedCreationDate(currentDate: { currentDate }), "26. Oct")
  }
}
