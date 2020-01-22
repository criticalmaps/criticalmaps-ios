//
//  CriticalMaps

import CoreLocation

extension CLLocationCoordinate2D {
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    var obfuscated: CLLocationCoordinate2D {
        let hundredMeterRange = (-0.009 ... 0.009)
        let seededLat = latitude + Double.random(in: hundredMeterRange)
        let seededLon = longitude + Double.random(in: hundredMeterRange)
        return CLLocationCoordinate2D(latitude: seededLat, longitude: seededLon)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
