//
//  ChatUITests.swift
//  CriticalMapsUITests
//
//  Created by Leonard Thomas on 6/24/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import XCTest

class ChatUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-observationMode", "YES"])
        app.launch()
    }

    func testSendButtonDisabledWithoutContent() {
        let app = XCUIApplication()
        app.buttons["Chat"].tap()
        XCTAssertFalse(app.buttons["SendButton"].isEnabled)
    }

    func testSendButtonIsEnabledWithContent() {
        let app = XCUIApplication()
        app.buttons["Chat"].tap()

        let textField = app.textFields["ChatInputTextField"]
        textField.tap()
        textField.typeText("Hello World")
        XCTAssertTrue(app.buttons["SendButton"].isEnabled)
    }
}
