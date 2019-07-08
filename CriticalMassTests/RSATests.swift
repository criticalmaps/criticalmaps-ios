//
//  RSATests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 5/5/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import CriticalMaps
import XCTest

class RSATests: XCTestCase {
    let keychainTag = "com.example.test.key"
    var key: RSAKey!

    override func setUp() {
        key = try! RSAKey(randomKey: keychainTag)
    }

    override func tearDown() {
        let key = try? RSAKey(fromKeychain: keychainTag)
        try? key?.delete()
    }

    func testSignAndVerify() throws {
        let test = "Hello World"
        let data = test.data(using: .utf8)!
        let signedData = try RSA.sign(data, privateKey: key.privateKey!)
        XCTAssertTrue(try RSA.verify(data, publicKey: key.publicKey!, signature: signedData))
    }
}
