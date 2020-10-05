//
//  KeychainHelperTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 7/8/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import CriticalMaps
import XCTest

class KeychainHelperTests: XCTestCase {
    var keychainReference = "SomeKey"
    var testData = "RandomKey".data(using: .utf8)!

    override func tearDown() {
        try? KeychainHelper.delete(with: keychainReference)
    }

    func testAdd() {
        XCTAssertNoThrow(try KeychainHelper.save(keyData: testData, with: keychainReference))
    }

    func testAddAndLoad() {
        let data = testData
        XCTAssertNoThrow(try KeychainHelper.save(keyData: data, with: keychainReference))
        var loadedData = Data()
        XCTAssertNoThrow(loadedData = try KeychainHelper.load(with: keychainReference))
        XCTAssertEqual(data, loadedData)
    }

    func testDelete() {
        XCTAssertNoThrow(try KeychainHelper.save(keyData: testData, with: keychainReference))
        XCTAssertNoThrow(try KeychainHelper.delete(with: keychainReference))
        XCTAssertThrowsError(try KeychainHelper.load(with: keychainReference))
    }
}
