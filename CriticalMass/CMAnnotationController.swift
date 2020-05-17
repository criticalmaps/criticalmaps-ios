//
//  CriticalMaps

import MapKit

@available(iOS 11.0, *)
final class CMMarkerAnnotationController: AnnotationController {
    private let rideChecker: RideChecker
    private let outdatedCheckTimeinterval: TimeInterval
    private var isRideOutdatedTimer: Timer?

    init(
        rideChecker: RideChecker,
        outdatedCheckTimeinterval: TimeInterval,
        mapView: MKMapView,
        annotationType: AnnotationController.AnnotationType,
        annotationViewType: AnnotationController.AnnotationViewType
    ) {
        self.rideChecker = rideChecker
        self.outdatedCheckTimeinterval = outdatedCheckTimeinterval
        super.init(
            mapView: mapView,
            annotationType: annotationType,
            annotationViewType: annotationViewType
        )
    }

    convenience init(
        mapView: MKMapView,
        rideChecker: RideChecker = RideChecker(),
        outdatedCheckTimeinterval: TimeInterval = 120
    ) {
        self.init(
            rideChecker: rideChecker,
            outdatedCheckTimeinterval: outdatedCheckTimeinterval,
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

    deinit {
        isRideOutdatedTimer?.invalidate()
    }

    override public func setup() {
        isRideOutdatedTimer = Timer.scheduledTimer(
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

final class CMAnnotationController: AnnotationController {
    private let rideChecker: RideChecker
    private let outdatedCheckTimeinterval: TimeInterval
    private var isRideOutdatedTimer: Timer?

    init(
        rideChecker: RideChecker,
        outdatedCheckTimeinterval: TimeInterval,
        mapView: MKMapView,
        annotationType: AnnotationController.AnnotationType,
        annotationViewType: AnnotationController.AnnotationViewType
    ) {
        self.rideChecker = rideChecker
        self.outdatedCheckTimeinterval = outdatedCheckTimeinterval
        super.init(
            mapView: mapView,
            annotationType: annotationType,
            annotationViewType: annotationViewType
        )
    }

    convenience init(
        mapView: MKMapView,
        rideChecker: RideChecker = RideChecker(),
        outdatedCheckTimeinterval: TimeInterval = 120
    ) {
        self.init(
            rideChecker: rideChecker,
            outdatedCheckTimeinterval: outdatedCheckTimeinterval,
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

    deinit {
        isRideOutdatedTimer?.invalidate()
    }

    override public func setup() {
        isRideOutdatedTimer = Timer.scheduledTimer(
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
