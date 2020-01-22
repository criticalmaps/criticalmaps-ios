//
//  CriticalMaps

import MapKit

@available(iOS 11.0, *)
class CMMarkerAnnotationView: MKMarkerAnnotationView {
    static let reuseIdentifier = String(describing: self)

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        markerTintColor = .white
        glyphImage = #imageLiteral(resourceName: "logo-m.pdf")
        canShowCallout = false
    }
}

class CMAnnotationView: MKAnnotationView {
    static let reuseIdentifier = String(describing: self)

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        image = #imageLiteral(resourceName: "event-marker.pdf")
        canShowCallout = true
    }
}
