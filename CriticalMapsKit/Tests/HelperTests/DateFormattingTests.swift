import Foundation
import Helpers
import Testing

struct DateFormattingTests {
  /// 3.10.2022, 11:09
  let testDate = Date(timeIntervalSince1970: 1664788190)

  @Test
  func `Dateformatter DateWithYear should format correctly`() {
    let formatted = testDate.formatted(Date.FormatStyle.dateWithoutYear)

    #expect(formatted == "3. Oct")
  }

  @Test
  func `IDHashStoreFormatter DateWithYear should format correctly`() {
    let formatted = DateFormatter.IDStoreHashDateFormatter.string(from: testDate)
    #expect(formatted == "2022-10-03")
  }
}
