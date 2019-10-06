//
//  CriticalMapsUITests.swift
//  CriticalMapsUITests
//
//  Created by Felizia Bernutz on 06.10.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import XCTest

class CriticalMapsUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app, waitForAnimations: false)
        app.launch()

        addUIInterruptionMonitor(withDescription: "Allow location permissions") { alert in
            alert.buttons["Allow While Using App"].tap()
            return true
        }
        app.tap()
    }

    func testScreenshots() {
        let app = XCUIApplication()
        snapshot("01_map")

        let closeButton = app.navigationBars.buttons.element(boundBy: 0).firstMatch
        let backButton = closeButton

        XCTContext.runActivity(named: "Show Chat") { _ in
            app.buttons["Chat"].tap()
            snapshot("02_chat")
            closeButton.tap()
        }

        XCTContext.runActivity(named: "Show Rules") { _ in
            app.buttons["Rules"].tap()
            snapshot("03_rules")

            let firstCell = app.tables.element(boundBy: 0).cells.element(boundBy: 0).firstMatch
            firstCell.tap()
            snapshot("04_rules_corken")

            backButton.tap()
            closeButton.tap()
        }

        XCTContext.runActivity(named: "Show Settings") { _ in
            app.buttons["Settings"].tap()
            snapshot("05_settings")
            closeButton.tap()
        }
    }

//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
