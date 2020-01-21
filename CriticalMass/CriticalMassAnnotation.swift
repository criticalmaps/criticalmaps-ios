//
//  CriticalMaps

import MapKit

class CriticalMassAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D

    init(
        title: String,
        locationName: String,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate

        super.init()
    }

    init(ride: Ride) {
        title = ride.title
        locationName = ride.location
        coordinate = ride.coordinate

        super.init()
    }

    var subtitle: String? {
        locationName
    }
}
