//
//  CriticalMaps

import MapKit

@available(iOS 11.0, *)
class CMMarkerAnnotationController: AnnotationController {
    var cmAnnotation: CriticalMassAnnotation? {
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

    public override func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkRide(notification:)),
            name: Notification.positionOthersChanged,
            object: nil
        )
    }

    @objc private func checkRide(notification _: Notification) {
        guard let rideAnnotation = cmAnnotation else {
            Logger.log(.debug, log: .default, "Expected annotation")
            return
        }
        if rideAnnotation.ride.isOutdated {
            mapView.removeAnnotation(rideAnnotation)
        }
    }
}

class CMAnnotationController: AnnotationController {
    var cmAnnotation: CriticalMassAnnotation? {
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

    public override func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkRide(notification:)),
            name: Notification.positionOthersChanged,
            object: nil
        )
    }

    @objc private func checkRide(notification _: Notification) {
        guard let rideAnnotation = cmAnnotation else {
            Logger.log(.debug, log: .default, "Expected annotation")
            return
        }
        if rideAnnotation.ride.isOutdated {
            mapView.removeAnnotation(rideAnnotation)
        }
    }
}
