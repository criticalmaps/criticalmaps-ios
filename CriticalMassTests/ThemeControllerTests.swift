//
//  ThemeControllerTests.swift
//  CriticalMapsTests
//
//  Created by Malte Bünz on 11.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import XCTest
@testable import CriticalMaps

class ThemeControllerTests: XCTestCase {
    
    var sut: ThemeController!
    
    override func setUp() {
        super.setUp()
        sut = ThemeController(store: MockThemeStore())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testChangingTheme() {
        // given
        let theme = Theme.dark
        // when
        sut.changeTheme(to: theme)
        // then
        XCTAssertEqual(sut.currentTheme, .dark)
    }
    
    func testControllerShouldReturnLightThemeWhenLoadForTheFirstTime() {
        // when
        let theme = sut.currentTheme
        // then
        XCTAssertEqual(theme, sut.currentTheme)
    }
    
    func testControllerShouldApplyDarkThemeWhenItWasSet() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let navBarColor = UINavigationBar.appearance().tintColor
        XCTAssertEqual(navBarColor!, Theme.dark.style.tintColor)
    }
}
