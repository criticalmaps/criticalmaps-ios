@testable import Helpers
import XCTest

class DateAdditionsTests: XCTestCase {
  // 21. January 2020 06:52:21 GMT
  let date = { Date(timeIntervalSince1970: 1_579_589_541) }
  
  func testGetCurrentDayShouldReturnDayAs21() {
    // when
    let day = Date.getCurrent(\.day, date)
    // then
    XCTAssertEqual(day, 21)
  }
  
  func testGetCurrentMonthShouldReturnMonth1() {
    // when
    let month = Date.getCurrent(\.month, date)
    // then
    XCTAssertEqual(month, 1)
  }
  
  func testGetCurrentYearShouldReturnDayAs2020() {
    // when
    let year = Date.getCurrent(\.year, date)
    // then
    XCTAssertEqual(year, 2020)
  }
  
  func testYesterDayShouldReturnEqualGeneratedDateFromTimestamp() {
    // given
    // 20. January 2020 06:52:21 GMT
    let yesterdayFromTimestamp = Date(timeIntervalSince1970: 1_579_503_141)
    // when
    let yesterday = Date.yesterday(date())
    // then
    XCTAssertEqual(yesterday, yesterdayFromTimestamp)
  }
}
