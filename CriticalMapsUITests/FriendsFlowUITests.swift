//
//  FriendsFlowUITests.swift
//  CriticalMapsUITests
//
//  Created by Felizia Bernutz on 30.12.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import XCTest

class FriendsFlowUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments += [
            "SKIP_ANIMATIONS",
            "ACTIVATE_FRIENDS",
        ]
        app.launch()

        addUIInterruptionMonitor(withDescription: "Allow location permissions") { alert in
            alert.buttons["Allow While Using App"].tap()
            return true
        }
        app.tap()
    }

    func testExample() {
        let app = XCUIApplication()

        XCTContext.runActivity(named: "Add Friend") { _ in
            app.buttons["Settings"].tap()
            let friends = app.tables.element(boundBy: 0).cells["Friends"]
            friends.tap()
        }
    }
}
