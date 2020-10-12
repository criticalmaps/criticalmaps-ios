import Foundation

extension DateFormatter {
    /// Short time formatter, without date.
    static let localeShortTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    /// Short date formatter, without time.
    static let localeShortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
}

extension DateComponentsFormatter {
    static func tweetDateFormatter(_ calendar: Calendar = .current) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.allowedUnits = [.day, .hour, .minute, .month, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        return formatter
    }
}
