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

    func testCreateRandomKeyAndLoadFromKeychain() {
        XCTAssertThrowsError(try RSAKey(fromKeychain: keychainTag))
        XCTAssertNoThrow(try RSAKey(randomKey: keychainTag))
        XCTAssertNoThrow(try RSAKey(fromKeychain: keychainTag))
    }

    func testDeleteKey() throws {
        let key = try RSAKey(randomKey: keychainTag)
        XCTAssertNoThrow(try RSAKey(fromKeychain: keychainTag))
        try key.delete()
        XCTAssertThrowsError(try RSAKey(fromKeychain: keychainTag))
    }

    func testRepresentToDataAndLoadFromData() throws {
        let key = try RSAKey(randomKey: keychainTag)
        let data = try key.publicKeyDataRepresentation()
        XCTAssertNoThrow(try RSAKey(data: data))
    }

    func testInitNonPermanentKey() throws {
        let key = try RSAKey(randomKey: keychainTag, isPermament: false)
        XCTAssertThrowsError(try key.delete())
    }
}
