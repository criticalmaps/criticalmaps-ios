import Helpers
import XCTest

final class DateFormattingTests: XCTestCase {
  // 3.10.2022, 11:09
  let testDate = Date(timeIntervalSince1970: 1664788190)

  func test_tweetDateFormatter() throws {
    
    let formatted = testDate.formatted(Date.FormatStyle.dateWithoutYear)
    
    XCTAssertEqual(formatted, "3. Oct")
  }
  
  func test_IDHashStoreFormatter() {
    let formatted = DateFormatter.IDStoreHashDateFormatter.string(from: testDate)
    XCTAssertEqual(formatted, "2022-10-03")
  }
}
