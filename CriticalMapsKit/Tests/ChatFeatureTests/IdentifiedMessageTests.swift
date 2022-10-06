import ChatFeature
import ComposableArchitecture
import XCTest

final class IdentifiedMessagesTests: XCTestCase {
  let date = Calendar.current.date(
    from: .init(
      timeZone: .init(secondsFromGMT: 0),
      year: 2020,
      month: 2,
      day: 2,
      hour: 2,
      minute: 2
    )
  )!

  func test_chatTime_Format() {
    let sut = IdentifiedChatMessage(
      id: "ID",
      message: "Hello World",
      timestamp: date.timeIntervalSince1970
    )

    var cal = Calendar.current
    cal.timeZone = .init(secondsFromGMT: 0)!
    let chatTime = date.formatted(Date.FormatStyle.chatTime(cal))

    XCTAssertEqual(
      chatTime,
      "02:02"
    )
  }
}
