//
//  SpringBoardHelper.swift
//  CriticalMapsUITests
//
//  Created by Leonard Thomas on 6/24/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import XCTest

// Created by Chase Holland, https://stackoverflow.com/a/36168101
class SpringboardHelper {
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

            sleep(1)

            springboard.alerts.buttons["Delete"].tap()
        }
    }
}
