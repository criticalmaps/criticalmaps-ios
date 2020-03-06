//
// Created for CriticalMaps in 2020

import Foundation

extension String {
    /// removes Date which is formatted like: dd.MM.yyyy
    func removedDatePattern() -> String {
        let pattern = " \\d{1,2}.\\d{1,2}.\\d{4}$"
        return removedRegexMatches(pattern: pattern)
    }

    func removedRegexMatches(pattern: String, replaceWith template: String = "") -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSRange(location: 0, length: count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: template)
        } catch {
            return self
        }
    }
}
