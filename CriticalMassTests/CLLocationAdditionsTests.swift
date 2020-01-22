//
//  CriticalMapsTests

import CoreLocation
@testable import CriticalMaps
import XCTest

class CLLocationAdditionsTests: XCTestCase {
    func testCoordinateObfuscate() {
        // given
        let coordinate = CLLocationCoordinate2D.TestData.rendsburg
        // when
        let obfuscatedCoordinate = coordinate.obfuscated
        // then
        XCTAssertNotEqual(coordinate, obfuscatedCoordinate)
    }
}
