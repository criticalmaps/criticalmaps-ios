//
//  FriendsFlowUITests.swift
//  CriticalMapsUITests
//
//  Created by Felizia Bernutz on 30.12.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import XCTest

class FriendsFlowUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
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

        resetFriendsIfNeeded()
    }

    func testAddFriendFromURL() {
        let friendsName = "TestName"

        XCTContext.runActivity(named: "Open App from Safari") { _ in
            Safari.openUrl("criticalmaps://follow?token=TestKey&name=\(friendsName)")
            XCTAssert(app.waitForExistence(timeout: 5))
        }

        XCTContext.runActivity(named: "Show and dismiss Alert about added Friend") { _ in
            let alert = app.alerts.element(boundBy: 0).firstMatch
            XCTAssert(alert.exists)
            XCTAssert(alert.staticTexts["\(friendsName) added"].exists)
            alert.buttons["OK"].tap()
        }

        XCTContext.runActivity(named: "Navigate to Friend List") { _ in
            app.buttons["Settings"].tap()
            let friends = app.tables.element(boundBy: 0).cells["Friends"]
            friends.tap()

            let cells = app.tables.element(boundBy: 0).cells

            // There should be displayed:
            // - one cell for the added friend
            // - your own cell
            XCTAssertEqual(cells.count, 2)
        }

        XCTContext.runActivity(named: "Remove Friend again") { _ in
            let cells = app.tables.element(boundBy: 0).cells
            cells.staticTexts[friendsName].swipeLeft()
            cells.buttons["Delete"].tap()

            // There should be displayed:
            // - your own cell
            XCTAssertEqual(cells.count, 1)
        }
    }
}

extension FriendsFlowUITests {
    func resetFriendsIfNeeded() {
        XCTContext.runActivity(named: "Empty Friends if needed") { _ in
            // Navigate to Friend List
            app.buttons["Settings"].tap()
            let friends = app.tables.element(boundBy: 0).cells["Friends"]
            friends.tap()

            let cells = app.tables.element(boundBy: 0).cells

            // if there is more than your own cell, delete all friends
            for _ in 1 ..< cells.count {
                cells.element(boundBy: 0).firstMatch.swipeLeft()
                cells.buttons["Delete"].tap()
            }

            // There should be displayed:
            // - your own cell
            XCTAssertEqual(cells.count, 1)

            // Navigate back to Map
            let back = app.navigationBars.buttons.element(boundBy: 0).firstMatch
            back.tap()
            back.tap()
            app.buttons["Follow"].tap()
        }
    }
}

private enum Safari {
    // credits: https://aross.se/posts/2018-06-17-ios-ui-tests-for-custom-url-scheme/
    static func openUrl(_ urlString: String) {
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")

        XCTContext.runActivity(named: "Launch Safari") { _ in
            safari.launch()
            XCTAssert(safari.waitForExistence(timeout: 10))
        }

        XCTContext.runActivity(named: "Open URL \(urlString) in Safari") { _ in
            let searchBar = safari.buttons["URL"]
            XCTAssert(searchBar.waitForExistence(timeout: 5))
            searchBar.tap()

            safari.typeText("\(urlString)")
            safari.typeText("\n")

            // An alert will open and ask you to launch the application.
            safari.buttons["Open"].tap()
        }
    }
}
