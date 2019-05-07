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
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEncodeObject() throws {
        let key = "TestKey".data(using: .utf8)!
        let friend = Friend(name: "hello", key: key)
        let urlObject = FollowURLObject(queryObject: friend)
        let urlString = try urlObject.asURL()

        let expectedURL = "criticalmaps:follow?name=hello&key=VGVzdEtleQ%3D%3D"
        XCTAssertEqual(urlString, expectedURL)
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
