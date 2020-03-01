import Foundation

extension DateFormatter {
    /// Short time formatter, without date.
    static let shortTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}
