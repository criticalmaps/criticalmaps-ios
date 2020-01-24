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

    private let rideChecker: RideChecker

    init(
        ridechecker: RideChecker = RideChecker(),
        mapView: MKMapView,
        annotationType: AnnotationController.AnnotationType,
        annotationViewType: AnnotationController.AnnotationViewType
    ) {
        rideChecker = ridechecker
        super.init(
            mapView: mapView,
            annotationType: annotationType,
            annotationViewType: annotationViewType
        )
    }

    convenience init(mapView: MKMapView, rideChecker: RideChecker = RideChecker()) {
        self.init(
            ridechecker: rideChecker,
            mapView: mapView,
            annotationType: CriticalMassAnnotation.self,
            annotationViewType: CMMarkerAnnotationView.self
        )
    }

    required init(
        mapView _: MKMapView,
        annotationType _: AnnotationType,
        annotationViewType _: AnnotationViewType
    ) {
        fatalError("init(mapView:annotationType:annotationViewType:) has not been implemented")
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
        if rideChecker.isRideOutdated(rideAnnotation.ride) {
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

    private let rideChecker: RideChecker

    init(
        ridechecker: RideChecker = RideChecker(),
        mapView: MKMapView,
        annotationType: AnnotationController.AnnotationType,
        annotationViewType: AnnotationController.AnnotationViewType
    ) {
        rideChecker = ridechecker
        super.init(
            mapView: mapView,
            annotationType: annotationType,
            annotationViewType: annotationViewType
        )
    }

    convenience init(mapView: MKMapView, rideChecker: RideChecker = RideChecker()) {
        self.init(
            ridechecker: rideChecker,
            mapView: mapView,
            annotationType: CriticalMassAnnotation.self,
            annotationViewType: CMAnnotationView.self
        )
    }

    required init(
        mapView _: MKMapView,
        annotationType _: AnnotationType,
        annotationViewType _: AnnotationViewType
    ) {
        fatalError("init(mapView:annotationType:annotationViewType:) has not been implemented")
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
        if rideChecker.isRideOutdated(rideAnnotation.ride) {
            mapView.removeAnnotation(rideAnnotation)
        }
    }
}
