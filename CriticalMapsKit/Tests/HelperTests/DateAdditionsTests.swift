import Helpers
import Testing

@Suite
struct DateAdditionsTests {
  // 21. January 2020 06:52:21 GMT
  let date = { Date(timeIntervalSince1970: 1579589541) }
  
  @Test("Get current day")
  func getCurrentDayShouldReturnDayAs21() {
    // when
    let day = Date.getCurrent(\.day, date)
    // then
    #expect(day == 21)
  }
  
  @Test("Get current month")
  func getCurrentMonthShouldReturnMonth1() {
    // when
    let month = Date.getCurrent(\.month, date)
    // then
    #expect(month == 1)
  }
  
  @Test("Get current year")
  func getCurrentYearShouldReturnDayAs2020() {
    // when
    let year = Date.getCurrent(\.year, date)
    // then
    #expect(year == 2020)
  }
}
