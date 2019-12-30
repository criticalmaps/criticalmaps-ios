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
        let key = "TestKey"
        let friend = Friend(name: "hello", token: key)
        let urlObject = FollowURLObject(queryObject: friend)
        let urlString = try urlObject.asURL()

        let expectedURL = "criticalmaps:follow?name=hello&token=TestKey"
        let alternateExpectedURL = "criticalmaps:follow?token=TestKey&name=hello"
        XCTAssert(urlString == expectedURL || urlString == alternateExpectedURL)
    }

    func testDecodeURL() throws {
        let urlString = "criticalmaps:follow?name=hello&token=TestKey"
        let object = try FollowURLObject.decode(from: urlString)

        let key = "TestKey"
        let expectedFriend = Friend(name: "hello", token: key)
        XCTAssertEqual(object.queryObject.name, expectedFriend.name)
        XCTAssertEqual(object.queryObject.token, expectedFriend.token)
    }
}
