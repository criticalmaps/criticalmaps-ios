//
//  CriticalMaps

import MapKit

@available(iOS 11.0, *)
final class CMMarkerAnnotationController: AnnotationController {
    private let rideChecker: RideChecker

    init(
        ridechecker: RideChecker,
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

    override func update(_ annotations: [MKAnnotation]) {
        mapView.addAnnotations(annotations)
    }

    @objc private func checkRide(notification _: Notification) {
        guard let rideAnnotation = mapView.annotations.first(
            where: { $0 is CriticalMassAnnotation }
        ) as? CriticalMassAnnotation else {
            Logger.log(.debug, log: .default, "Expected annotation")
            return
        }
        if rideChecker.isRideOutdated(rideAnnotation.ride) {
            mapView.removeAnnotation(rideAnnotation)
        }
    }
}

final class CMAnnotationController: AnnotationController {
    private let rideChecker: RideChecker

    init(
        ridechecker: RideChecker,
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

    override func update(_ annotations: [MKAnnotation]) {
        mapView.addAnnotations(annotations)
    }

    @objc private func checkRide(notification _: Notification) {
        guard let rideAnnotation = mapView.annotations.first(
            where: { $0 is CriticalMassAnnotation }
        ) as? CriticalMassAnnotation else {
            Logger.log(.debug, log: .default, "Expected annotation")
            return
        }
        if rideChecker.isRideOutdated(rideAnnotation.ride) {
            mapView.removeAnnotation(rideAnnotation)
        }
    }
}
