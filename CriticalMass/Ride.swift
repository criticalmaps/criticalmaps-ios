//
//  CriticalMaps

import CoreLocation
import Foundation

struct Ride: Hashable, Codable {
    let id: Int
    let slug: String?
    let title: String
    let description: String?
    let dateTime: Date
    let location: String?
    let latitude: Double
    let longitude: Double
    let estimatedParticipants: Int?
    let estimatedDistance: Double?
    let estimatedDuration: Double?
}

extension Ride {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var titleAndTime: String {
        let titleWithoutDate = title.removedDatePattern()
        return "\(titleWithoutDate)\n\(dateTime.humanReadableDate()) - \(dateTime.humanReadableTime())"
    }
}

private extension String {
    func removedDatePattern() -> String {
        // assuming the date is formatted like dd.MM.yyyy. Also removes the whitespace before the date
        let pattern = " \\d{1,2}.\\d{1,2}.\\d{4}$"
        return removedRegexMatches(pattern: pattern)
    }

    private func removedRegexMatches(pattern: String, replaceWith template: String = "") -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSRange(location: 0, length: count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: template)
        } catch {
            return self
        }
    }
}
