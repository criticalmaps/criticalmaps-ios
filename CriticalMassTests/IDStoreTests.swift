//
//  IDStoreTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 5/5/19.
//

import CriticalMaps
import XCTest

class IDStoreTests: XCTestCase {
    func testIDDoesntChange() {
        let date = Date(timeIntervalSince1970: 1_557_057_968)
        let currentID = IDStore(currentDate: date).id

        let newDate = date.addingTimeInterval(7200)
        let newID = IDStore(currentDate: newDate).id

        XCTAssertEqual(currentID, newID)
    }

    func testIDDoesChange() {
        let date = Date(timeIntervalSince1970: 1_557_057_968)
        let currentID = IDStore(currentDate: date).id

        let newDate = date.addingTimeInterval(86400)
        let newID = IDStore(currentDate: newDate).id

        XCTAssertNotEqual(currentID, newID)
    }
}
