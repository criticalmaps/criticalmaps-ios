//
//  CriticalMaps

import MapKit

final class CMMarkerAnnotationController: AnnotationController {
    private let rideChecker: RideChecker
    private let outdatedCheckTimeinterval: TimeInterval
    private var timerProvider: Timer.Type = Timer.self

    init(
        rideChecker: RideChecker,
        outdatedCheckTimeinterval: TimeInterval,
        mapView: MKMapView,
        annotationType: AnnotationController.AnnotationType,
        annotationViewType: AnnotationController.AnnotationViewType,
        timer: Timer.Type
    ) {
        self.rideChecker = rideChecker
        self.outdatedCheckTimeinterval = outdatedCheckTimeinterval
        timerProvider = timer
        super.init(
            mapView: mapView,
            annotationType: annotationType,
            annotationViewType: annotationViewType
        )
    }

    convenience init(
        mapView: MKMapView,
        rideChecker: RideChecker = RideChecker(),
        outdatedCheckTimeinterval: TimeInterval = 120,
        timer: Timer.Type = Timer.self
    ) {
        self.init(
            rideChecker: rideChecker,
            outdatedCheckTimeinterval: outdatedCheckTimeinterval,
            mapView: mapView,
            annotationType: CriticalMassAnnotation.self,
            annotationViewType: CMMarkerAnnotationView.self,
            timer: timer
        )
    }

    required init(
        mapView _: MKMapView,
        annotationType _: AnnotationType,
        annotationViewType _: AnnotationViewType
    ) {
        fatalError("init(mapView:annotationType:annotationViewType:) has not been implemented")
    }

    override public func setup() {
        timerProvider.scheduledTimer(
            timeInterval: outdatedCheckTimeinterval,
            target: self,
            selector: #selector(checkRide),
            userInfo: nil,
            repeats: true
        )
    }

    override func update(_ annotations: [MKAnnotation]) {
        mapView.addAnnotations(annotations)
    }

    @objc private func checkRide() {
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
