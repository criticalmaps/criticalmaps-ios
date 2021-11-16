import ChatFeature
import ComposableArchitecture
import XCTest

class IdentifiedMessagesTests: XCTestCase {
  func test_chatTime_Format() {
    let sut = IdentifiedChatMessage(
      id: "ID",
      message: "Hello World",
      timestamp: Date(timeIntervalSinceReferenceDate: 0).timeIntervalSince1970
    )
    
    let chatTime = sut.chatTime
    
    XCTAssertEqual(chatTime, "1:00 AM")
  }
}
