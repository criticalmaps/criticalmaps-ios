//
//  CriticalMapsTests

@testable import CriticalMaps
import MapKit
import XCTest

@available(iOS 11.0, *)
class CMMarkerAnnotationControllerTests: XCTestCase {
    var annotationController: CMMarkerAnnotationController!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        annotationController = nil
        super.tearDown()
    }

    func test_ControllerShouldRemoveAnnotationWhenRideStartedMoreThen30MinutesAgo() {
        // given
        let ride = Ride.TestData.cmBerlin
        let rideAnnotation = CriticalMassAnnotation(ride: ride)
        var timeTraveler = TimeTraveler(ride.dateTime)
        // when
        timeTraveler.travel(by: 1900)
        let rideChecker = RideChecker(timeTraveler)
        annotationController = CMMarkerAnnotationController(
            mapView: MKMapView(),
            rideChecker: rideChecker
        )
        annotationController.cmAnnotation = rideAnnotation
        NotificationCenter.default.post(name: Notification.positionOthersChanged, object: nil)
        // then
        XCTAssertTrue(annotationController.mapView.annotations.isEmpty)
    }

    func test_ControllerShouldRemoveAnnotationWhenRideStartedLessThen30MinutesAgo() {
        // given
        let ride = Ride.TestData.cmBerlin
        let rideAnnotation = CriticalMassAnnotation(ride: ride)
        var timeTraveler = TimeTraveler(ride.dateTime)
        // when
        timeTraveler.travel(by: 1799)
        let rideChecker = RideChecker(timeTraveler)
        annotationController = CMMarkerAnnotationController(
            mapView: MKMapView(),
            rideChecker: rideChecker
        )
        annotationController.cmAnnotation = rideAnnotation
        NotificationCenter.default.post(name: Notification.positionOthersChanged, object: nil)
        // then
        XCTAssertFalse(annotationController.mapView.annotations.isEmpty)
    }
}
