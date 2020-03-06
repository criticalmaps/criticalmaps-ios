//
//  CriticalMapsTests

@testable import CriticalMaps
import XCTest

class TimeTravlelerTests: XCTestCase {
    var sut: TimeTraveler!

    override func setUp() {
        super.setUp()
        let date = Date(timeIntervalSince1970: 1_600_000_000) // Sunday, September 13, 2020 2:26:40 PM GMT+02:00 DST
        sut = TimeTraveler(date)
    }

    func testTimeTravelerShouldGenerateTimeInFutureWhenTravelByMinutes() {
        // given
        let futureDate = Date(timeIntervalSince1970: 1_600_000_060)
        // when
        sut.travelTime(by: .minutes(1))
        // then
        XCTAssertEqual(futureDate, sut.generateDate())
    }

    func testTimeTravelerShouldGenerateTimeInFutureWhenTravelByHours() {
        // given
        let futureDate = Date(timeIntervalSince1970: 1_600_003_600)
        // when
        sut.travelTime(by: .hours(1))
        // then
        XCTAssertEqual(futureDate, sut.generateDate())
    }

    func testTimeTravelerShouldGenerateTimeInPastWhenTravelByMinutes() {
        // given
        let futureDate = Date(timeIntervalSince1970: 1_599_999_940)
        // when
        sut.travelTime(by: .minutes(-1))
        // then
        XCTAssertEqual(futureDate, sut.generateDate())
    }

    func testTimeTravelerShouldGenerateTimeInPastWhenTravelByHours() {
        // given
        let futureDate = Date(timeIntervalSince1970: 1_599_996_400)
        // when
        sut.travelTime(by: .hours(-1))
        // then
        XCTAssertEqual(futureDate, sut.generateDate())
    }
}
