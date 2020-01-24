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
}

struct RideChecker {
    private let timeTraveler: TimeTraveler

    func isRideOutdated(_ ride: Ride) -> Bool {
        ride.dateTime.timeIntervalSince(timeTraveler.generateDate()) < -1800
    }
}

extension RideChecker {
    init(_ timeTraveler: TimeTraveler = TimeTraveler()) {
        self.init(timeTraveler: timeTraveler)
    }
}
