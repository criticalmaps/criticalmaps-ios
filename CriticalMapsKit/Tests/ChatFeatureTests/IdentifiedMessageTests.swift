import ChatFeature
import ComposableArchitecture
import Foundation
import SharedModels
import Testing

struct IdentifiedMessagesTests {
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

  @Test
  func chatTime_Format() {
    var cal = Calendar.current
    cal.timeZone = .init(secondsFromGMT: 0)!
    let chatTime = date.formatted(Date.FormatStyle.chatTime(cal))

    #expect(chatTime == "02:02")
  }
}
