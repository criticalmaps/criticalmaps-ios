//
//  CriticalMapsUITests.swift
//  CriticalMapsUITests
//
//  Created by Leonard Thomas on 6/24/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import XCTest

extension XCTestCase {
    func waitForLocationDialog(allow: Bool) {
        addUIInterruptionMonitor(withDescription: "Location Permission") { (element) -> Bool in
            let alertButton = element.buttons[allow ? "Always Allow" : "Don’t Allow"]
            if alertButton.exists {
                alertButton.tap()
                return true
            }
            XCUIApplication().tap()
            return false
        }
        XCUIApplication().tap()
    }
}

// Created by Chase Holland, https://stackoverflow.com/a/36168101
class Springboard {
    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    class func deleteMyApp() {
        XCUIApplication().terminate()

        // Force delete the app from the springboard
        let icon = springboard.icons["CriticalMaps"]
        if icon.exists {
            let iconFrame = icon.frame
            let springboardFrame = springboard.frame
            icon.press(forDuration: 1.3)

            // Tap the little "X" button at approximately where it is. The X is not exposed directly
            springboard.coordinate(withNormalizedOffset: CGVector(dx: (iconFrame.minX + 3) / springboardFrame.maxX, dy: (iconFrame.minY + 3) / springboardFrame.maxY)).tap()

            springboard.alerts.buttons["Delete"].tap()
        }
    }
}

class CriticalMapsUITests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        Springboard.deleteMyApp()
    }

    func testOpenSettingsAfterDenyingLocationAccess() {
        let app = XCUIApplication()
        app.launch()

        waitForLocationDialog(allow: false)
        app.buttons["SettingsButton"].tap()
    }

    func testApprovingLocatioonAccess() {
        let app = XCUIApplication()
        app.launch()

        waitForLocationDialog(allow: true)
        XCTAssertFalse(app.buttons["SettingsButton"].exists)
    }
}
