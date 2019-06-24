
//
//  XCTest+Extension.swift
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
