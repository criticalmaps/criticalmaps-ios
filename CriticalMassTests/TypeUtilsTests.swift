//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import XCTest

class TypeUtilsTests: XCTestCase {
    func testCastToMap() {
        let input: [Any] = [1, 2, "3", 4, "5"]
        let expectedOutput = [1, 2, 4]
        let output = input.compactMap(castTo(Int.self))
        XCTAssertEqual(expectedOutput, output)
    }

    func testCastTo() {
        XCTAssertEqual(castTo(Int.self)(1 as Any), 1)
    }

    func testCannotCastTo() {
        XCTAssertNil(castTo(Int.self)("1"))
    }

    func testCanBeCastedTo() {
        XCTAssertTrue(canBeCastedTo(Int.self)(1 as Any))
    }

    func testCannotBeCastedTo() {
        XCTAssertFalse(canBeCastedTo(Int.self)("1" as Any))
    }
}
