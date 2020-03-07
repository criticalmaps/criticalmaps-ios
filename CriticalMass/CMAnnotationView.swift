//
//  CriticalMaps

import MapKit

@available(iOS 11.0, *)
final class CMMarkerAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        didSet { commonInit() }
    }

    private func commonInit() {
        markerTintColor = .white
        glyphImage = UIImage(named: "logo-m")
        canShowCallout = false
    }
}

class CMAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        image = UIImage(named: "event-marker")
        canShowCallout = true
    }
}