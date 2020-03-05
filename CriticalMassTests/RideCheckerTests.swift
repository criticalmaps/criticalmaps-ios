//
//  CriticalMapsTests

@testable import CriticalMaps
import XCTest

class RideCheckerTests: XCTestCase {
    func testRideCheckerShouldMarkRideOutedatedWhenRideIsInPast() {
        // given
        let ride = Ride.TestData.cmBerlin
        let timeTraveler = TimeTraveler(ride.dateTime)
        let rideChecker = RideChecker(timeTraveler)
        // when
        let isRideOutDated = rideChecker.isRideOutdated(Ride.TestData.completedCMBerlin)
        // then
        XCTAssertTrue(isRideOutDated)
    }

    func testRideCheckerShouldMarkRideValidWhenRideIsInFuture() {
        // given
        let ride = Ride.TestData.cmBerlin
        let timeTraveler = TimeTraveler(ride.dateTime)
        timeTraveler.travelTime(by: .hours(-2))
        let rideChecker = RideChecker(timeTraveler)
        // when
        let isRideOutDated = rideChecker.isRideOutdated(ride)
        // then
        XCTAssertFalse(isRideOutDated)
    }
}
