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

        // then
        expectToEventually(annotationController.mapView.annotations.isEmpty)
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

        expectToEventually(!annotationController.mapView.annotations.isEmpty)
    }
}
