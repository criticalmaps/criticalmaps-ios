import Foundation
import Helpers
import Testing

struct DateAdditionsTests {
  /// 21. January 2020 06:52:21 GMT
  let date = { Date(timeIntervalSince1970: 1579589541) }
  
  @Test
  func `Get current day`() {
    // when
    let day = Date.getCurrent(\.day, date)
    // then
    #expect(day == 21)
  }
  
  @Test
  func `Get current month`() {
    // when
    let month = Date.getCurrent(\.month, date)
    // then
    #expect(month == 1)
  }
  
  @Test
  func `Get current year`() {
    // when
    let year = Date.getCurrent(\.year, date)
    // then
    #expect(year == 2020)
  }
}
