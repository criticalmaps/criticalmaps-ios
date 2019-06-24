//
//  LocationPermissionUITests.swift
//  CriticalMapsUITests
//
//  Created by Leonard Thomas on 6/24/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import XCTest

class LocationPermissionUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-observationMode", "YES"])
        app.launch()
    }

    override func tearDown() {
        SpringboardHelper.deleteMyApp()
        super.tearDown()
    }

    func testOpenSettingsAfterDenyingLocationAccess() {
        let app = XCUIApplication()

        waitForLocationDialog(allow: false)
        app.buttons["SettingsButton"].tap()
    }

    func testApprovingLocatioonAccess() {
        let app = XCUIApplication()

        waitForLocationDialog(allow: true)
        XCTAssertFalse(app.buttons["SettingsButton"].exists)
    }
}
