import Foundation

public extension DateFormatter {
  static func chatMessageViewFormatter(_ calendar: Calendar = .current) -> DateFormatter {
    let formatter = DateFormatter.localeShortTimeFormatter
    formatter.calendar = calendar
    formatter.timeZone = calendar.timeZone
    return formatter
  }
  
  /// Short time formatter, without date.
  static let localeShortTimeFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = .autoupdatingCurrent
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    return dateFormatter
  }()
  
  /// Short date formatter, without time.
  static let localeShortDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = .autoupdatingCurrent
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    return dateFormatter
  }()
  
  /// Format to display only the day and a medium format month -> 28 Okt.
  static let mediumDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("MMM. d")
    return dateFormatter
  }()
  
  static let IDStoreHashDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
}

public extension DateComponentsFormatter {
  /// Formatter to handle Twitter
  static func tweetDateFormatter(_ calendar: Calendar = .current) -> DateComponentsFormatter {
    let formatter = DateComponentsFormatter()
    formatter.calendar = calendar
    formatter.allowedUnits = [.day, .hour, .minute, .month]
    formatter.unitsStyle = .short
    formatter.maximumUnitCount = 1
    return formatter
  }
}
