//
//  RSAKeyTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 5/5/19.
//

import CriticalMaps
import XCTest

class RSAKeyTests: XCTestCase {
    let keychainTag = "com.example.test.key"

    override func tearDown() {
        let key = try? RSAKey(fromKeychain: keychainTag)
        try? key?.delete()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
