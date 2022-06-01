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

    XCTAssertEqual(
      chatTime,
      DateFormatter.localeShortTimeFormatter.string(from: Date(timeIntervalSince1970: sut.timestamp))
    )
  }
}
