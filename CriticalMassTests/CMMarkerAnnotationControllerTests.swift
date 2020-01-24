//
//  CriticalMapsTests

@testable import CriticalMaps
import MapKit
import XCTest

@available(iOS 11.0, *)
class CMMarkerAnnotationControllerTests: XCTestCase {
    var sut: CMMarkerAnnotationController!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        sut = nil
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
        sut = CMMarkerAnnotationController(
            mapView: MKMapView(),
            rideChecker: rideChecker
        )
        sut.cmAnnotation = rideAnnotation
        NotificationCenter.default.post(name: Notification.positionOthersChanged, object: nil)
        // then
        XCTAssertTrue(sut.mapView.annotations.isEmpty)
    }

    func test_ControllerShouldRemoveAnnotationWhenRideStartedLessThen30MinutesAgo() {
        // given
        let ride = Ride.TestData.cmBerlin
        let rideAnnotation = CriticalMassAnnotation(ride: ride)
        var timeTraveler = TimeTraveler(ride.dateTime)
        // when
        timeTraveler.travel(by: 1799)
        let rideChecker = RideChecker(timeTraveler)
        sut = CMMarkerAnnotationController(
            mapView: MKMapView(),
            rideChecker: rideChecker
        )
        sut.cmAnnotation = rideAnnotation
        NotificationCenter.default.post(name: Notification.positionOthersChanged, object: nil)
        // then
        XCTAssertFalse(sut.mapView.annotations.isEmpty)
    }
}
