import Foundation

let datePattern = #" \d{1,2}.\d{1,2}.\d{4}$"#

extension String {
  /// removes Date from a String which is formatted like: dd.MM.yyyy
  public func removedDatePattern() -> String {
    removedRegexMatches(pattern: datePattern)
  }

  func removedRegexMatches(pattern: String, replaceWith template: String = "") -> String {
    do {
      let regex = try NSRegularExpression(
        pattern: pattern,
        options: NSRegularExpression.Options.caseInsensitive
      )
      let range = NSRange(location: 0, length: count)

      return regex.stringByReplacingMatches(
        in: self,
        options: [],
        range: range,
        withTemplate: template
      )
    } catch {
      debugPrint(error.localizedDescription)
      return self
    }
  }
}
