//
//  CriticalMapsTests

@testable import CriticalMaps
import MapKit
import XCTest

@available(iOS 11.0, *)
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
        // then
        wait(interval: 0.2) {
            XCTAssertTrue(self.annotationController.mapView.annotations.isEmpty)
        }
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
        // then
        wait(interval: 0.2) {
            XCTAssertFalse(self.annotationController.mapView.annotations.isEmpty)
        }
    }
}
