//
//  FollowURLObjectTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 5/7/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import XCTest

class FollowURLObjectTests: XCTestCase {
    func testEncodeObject() throws {
        let key = "TestKey".data(using: .utf8)!
        let friend = Friend(name: "hello", key: key)
        let urlObject = FollowURLObject(queryObject: friend)
        let urlString = try urlObject.asURL()

        let expectedURL = "criticalmaps:follow?name=hello&key=VGVzdEtleQ%3D%3D"
        let alternateExpectedURL = "criticalmaps:follow?key=VGVzdEtleQ%3D%3D&name=hello"
        XCTAssert(urlString == expectedURL || urlString == alternateExpectedURL)
    }

    func testDecodeURL() throws {
        let urlString = "criticalmaps:follow?name=hello&key=VGVzdEtleQ%3D%3D"
        let object = try FollowURLObject.decode(from: urlString)

        let key = "TestKey".data(using: .utf8)!
        let expectedFriend = Friend(name: "hello", key: key)
        XCTAssertEqual(object.queryObject.name, expectedFriend.name)
        XCTAssertEqual(object.queryObject.key, expectedFriend.key)
    }
}
