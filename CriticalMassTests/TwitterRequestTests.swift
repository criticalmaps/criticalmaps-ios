//
//  TwitterRequestTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 11.02.20.
//  Copyright © 2020 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import XCTest

class TwitterRequestTests: XCTestCase {
    func testMakeRequest() {
        XCTAssertNoThrow(try TwitterRequest().makeRequest())
    }
}
