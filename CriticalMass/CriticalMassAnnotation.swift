//
//  CriticalMaps

import MapKit

class CriticalMassAnnotation: NSObject, MKAnnotation {
    let ride: Ride
    let rideCoordinate: CLLocationCoordinate2D

    init?(ride: Ride) {
        guard let rideCoordinate = ride.coordinate else {
            return nil
        }
        self.rideCoordinate = rideCoordinate
        self.ride = ride
        super.init()
    }

    var title: String? {
        ride.titleAndTime
    }

    @objc dynamic var coordinate: CLLocationCoordinate2D {
        rideCoordinate
    }

    var subtitle: String? {
        ride.location
    }
}
