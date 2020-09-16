//
//  CriticalMapsTests

@testable import CriticalMaps
import MapKit
import XCTest

class CMMarkerAnnotationControllerTests: XCTestCase {
    var annotationController: CMMarkerAnnotationController!

    override func tearDown() {
        annotationController = nil
        super.tearDown()
    }

    func test_ControllerShouldRemoveAnnotationWhenRideStartedMoreThen30MinutesAgo() {
        // given
        let ride = Ride.TestData.cmBerlin
        let rideAnnotation = CriticalMassAnnotation(ride: ride)
        let timeTraveler = TimeTraveler(ride.dateTime)
        // when
        timeTraveler.travelTime(by: .minutes(31))
        let rideChecker = RideChecker(timeTraveler)
        annotationController = CMMarkerAnnotationController(
            mapView: MKMapView(),
            rideChecker: rideChecker,
            outdatedCheckTimeinterval: 0.1
        )
        annotationController.update([rideAnnotation])
        let exp = expectation(description: "Wait for outdated check")
        wait(interval: 0.2) {
            exp.fulfill()
        }
        // then
        wait(for: [exp], timeout: 0.3)
        XCTAssertTrue(annotationController.mapView.annotations.isEmpty)
    }

    func test_ControllerShouldNotRemoveAnnotationWhenRideStartedLessThen30MinutesAgo() {
        // given
        let ride = Ride.TestData.cmBerlin
        let rideAnnotation = CriticalMassAnnotation(ride: ride)
        let timeTraveler = TimeTraveler(ride.dateTime)
        // when
        timeTraveler.travelTime(by: .minutes(29))
        let rideChecker = RideChecker(timeTraveler)
        annotationController = CMMarkerAnnotationController(
            mapView: MKMapView(),
            rideChecker: rideChecker,
            outdatedCheckTimeinterval: 0.1
        )
        annotationController.update([rideAnnotation])
        let exp = expectation(description: "Wait for outdated check")
        wait(interval: 0.2) {
            exp.fulfill()
        }
        // then
        wait(for: [exp], timeout: 0.3)
        XCTAssertFalse(annotationController.mapView.annotations.isEmpty)
    }
}
