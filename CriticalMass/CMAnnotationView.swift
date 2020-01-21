//
//  CriticalMaps

import MapKit

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
