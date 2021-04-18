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

    func test_ControllerShouldRemoveAnnotationWhenRideStartedMoreThen30MinutesAgo() throws {
        // given
        let ride = Ride.TestData.cmBerlin
        let timeTraveler = TimeTraveler(ride.dateTime)
        // when
        timeTraveler.travelTime(by: .minutes(31))
        let rideChecker = RideChecker(timeTraveler)
        annotationController = CMMarkerAnnotationController(
            mapView: MKMapView(),
            rideChecker: rideChecker,
            outdatedCheckTimeinterval: 0.0
        )
        let rideAnnotation = try XCTUnwrap(CriticalMassAnnotation(ride: ride))

        annotationController.update([rideAnnotation])
        let exp = expectation(description: "Wait for outdated check")
        wait(interval: 0.1) {
            exp.fulfill()
        }
        // then
        wait(for: [exp], timeout: 0.5)
        XCTAssertTrue(annotationController.mapView.annotations.isEmpty)
    }

    func test_ControllerShouldNotRemoveAnnotationWhenRideStartedLessThen30MinutesAgo() throws {
        // given
        let ride = Ride.TestData.cmBerlin
        let timeTraveler = TimeTraveler(ride.dateTime)
        // when
        timeTraveler.travelTime(by: .minutes(29))
        let rideChecker = RideChecker(timeTraveler)
        annotationController = CMMarkerAnnotationController(
            mapView: MKMapView(),
            rideChecker: rideChecker,
            outdatedCheckTimeinterval: 0.0
        )
        let rideAnnotation = try XCTUnwrap(CriticalMassAnnotation(ride: ride))
        annotationController.update([rideAnnotation])
        let exp = expectation(description: "Wait for outdated check")
        wait(interval: 0.1) {
            exp.fulfill()
        }
        // then
        wait(for: [exp], timeout: 0.5)
        XCTAssertFalse(annotationController.mapView.annotations.isEmpty)
    }
}
