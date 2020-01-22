//
//  CriticalMaps

import MapKit

@available(iOS 11.0, *)
class CMMarkerAnnotationController: AnnotationController {
    var cmAnnotation: MKAnnotation? {
        didSet {
            guard let annotation = cmAnnotation else {
                return
            }
            mapView.addAnnotation(annotation)
        }
    }

    convenience init(mapView: MKMapView) {
        self.init(
            mapView: mapView,
            annotationType: CriticalMassAnnotation.self,
            annotationViewType: CMMarkerAnnotationView.self
        )
    }
}

class CMAnnotationController: AnnotationController {
    var cmAnnotation: MKAnnotation? {
        didSet {
            guard let annotation = cmAnnotation else {
                return
            }
            mapView.addAnnotation(annotation)
        }
    }

    convenience init(mapView: MKMapView) {
        self.init(
            mapView: mapView,
            annotationType: CriticalMassAnnotation.self,
            annotationViewType: CMAnnotationView.self
        )
    }
}
