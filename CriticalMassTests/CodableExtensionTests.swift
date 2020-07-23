//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import Foundation
import XCTest

class CodableExtensionsTests: XCTestCase {
    let testModel = [1, 2, 3]

    func testencodedHelperFunctionShouldEncode() throws {
        let testModelEncoded = try testModel.encoded()

        let testData = try JSONEncoder().encode(testModel)
        XCTAssertEqual(testModelEncoded, testData)
    }

    func testDecodedHelperFunctionShouldDecode() throws {
        let encodedTestModel = try JSONEncoder().encode(testModel)
        let decodedTestModed: [Int] = try encodedTestModel.decoded()

        XCTAssertEqual(decodedTestModed, testModel)
    }
}
