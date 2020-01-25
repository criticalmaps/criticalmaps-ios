//
//  CriticalMapsTests

import CoreLocation
@testable import CriticalMaps
import XCTest

class CoordinateObfuscatorTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ObfuscatorShouldReturnAlteredCoordinate() {
        // given
        let alexanderPlatz = CLLocationCoordinate2D.TestData.alexanderPlatz
        // when
        let alteredCoordinate = CoordinateObfuscator.obfuscate(alexanderPlatz)
        // then
        XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
    }

    func test_ObfuscatorShouldReturnCoordinateWithAlteredFirstDecimal() {
        // given
        let alexanderPlatz = CLLocationCoordinate2D.TestData.alexanderPlatz
        // when
        let alteredCoordinate = CoordinateObfuscator.obfuscate(alexanderPlatz, precisionType: .firstDecimal)
        // then
        XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
    }

    func test_ObfuscatorShouldReturnCoordinateWithAlteredSecondDecimal() {
        // given
        let alexanderPlatz = CLLocationCoordinate2D.TestData.alexanderPlatz
        // when
        let alteredCoordinate = CoordinateObfuscator.obfuscate(alexanderPlatz, precisionType: .thirdDecimal)
        // then
        XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
    }

    func test_ObfuscatorShouldReturnCoordinateWithAlteredFourthDecimal() {
        // given
        let alexanderPlatz = CLLocationCoordinate2D.TestData.alexanderPlatz
        // when
        let alteredCoordinate = CoordinateObfuscator.obfuscate(alexanderPlatz, precisionType: .fourthDecimal)
        // then
        XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
    }

    func test_ObfuscatorShouldReturnCoordinateWithCustomRange() {
        // given
        let alexanderPlatz = CLLocationCoordinate2D.TestData.alexanderPlatz
        // when
        let alteredCoordinate = CoordinateObfuscator.obfuscate(
            alexanderPlatz,
            precisionType: .custom(0.0000004 ... 0.0004)
        )
        // then
        XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
    }
}
