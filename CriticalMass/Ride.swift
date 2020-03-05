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
        return "\(titleWithoutDate)\n\(dateTime.humanReadableDate) - \(dateTime.humanReadableTime)"
    }
}
