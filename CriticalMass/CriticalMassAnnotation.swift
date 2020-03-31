//
//  CriticalMaps

import MapKit

class CriticalMassAnnotation: NSObject, MKAnnotation {
    let ride: Ride

    init(ride: Ride) {
        self.ride = ride
        super.init()
    }

    var title: String? {
        ride.titleAndTime
    }

    @objc dynamic var coordinate: CLLocationCoordinate2D {
        ride.coordinate
    }

    var subtitle: String? {
        ride.location
    }
}
