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

@available(iOS 11.0, *)
class CMMarkerAnnotationView: MKMarkerAnnotationView {
    static let reuseIdentifier = "CMMarkerAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        markerTintColor = .black
        glyphImage = UIImage(named: "cmLogoWhite")
        canShowCallout = false
    }
}

class CMAnnotationView: MKAnnotationView {
    static let reuseIdentifier = "CMAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        image = UIImage(named: "cmLogoWhite")
        canShowCallout = false
    }
}
