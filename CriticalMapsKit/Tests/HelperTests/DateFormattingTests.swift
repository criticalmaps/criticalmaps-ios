import Foundation
import Helpers
import Testing

struct DateFormattingTests {
  // 3.10.2022, 11:09
  let testDate = Date(timeIntervalSince1970: 1664788190)

  @Test("Dateformatter DateWithYear should format correctly")
  func tootDateFormatter() throws {
    let formatted = testDate.formatted(.dateWithoutYear)

    #expect(formatted == "3. Oct")
  }

  @Test("IDHashStoreFormatter DateWithYear should format correctly")
  func IDHashStoreFormatter() {
    let formatted = DateFormatter.IDStoreHashDateFormatter.string(from: testDate)
    #expect(formatted == "2022-10-03")
  }
}
