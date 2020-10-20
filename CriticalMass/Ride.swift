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
    let disabledReason: String?
    let disabledReasonMessage: String?
    let rideType: RideType?
}

extension Ride {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var titleAndTime: String {
        let titleWithoutDate = title.removedDatePattern()
        return """
        \(titleWithoutDate)
        \(dateTime.humanReadableDate) - \(dateTime.humanReadableTime)
        """
    }

    var shareMessage: String {
        guard let location = location else {
            return titleAndTime
        }
        return """
        \(titleAndTime)
        \(location)
        """
    }
}

import MapKit
extension Ride {
    func openInMaps(_ options: [String: Any] = [
        MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
    ]) {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location
        mapItem.openInMaps(launchOptions: options)
    }
}

extension Ride {
    enum RideType: String, CaseIterable, Codable {
        case criticalMass = "CRITICAL_MASS"
        case kidicalMass = "KIDICAL_MASS"
        case nightride = "NIGHT_RIDE"
        case lunchride = "LUNCH_RIDE"
        case dawnride = "DAWN_RIDE"
        case duskride = "DUSK_RIDE"
        case demonstration = "DEMONSTRATION"
        case alleycat = "ALLEYCAT"
        case tour = "TOUR"
        case event = "EVENT"

        var title: String {
            rawValue
                .replacingOccurrences(of: "_", with: " ")
                .capitalized
        }
    }
}

extension Ride {
    static let eventRadii: [Int] = [10, 20, 30, 40]
}
