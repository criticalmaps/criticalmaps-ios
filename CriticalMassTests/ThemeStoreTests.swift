//
//  ThemeStoreTests.swift
//  CriticalMapsTests
//
//  Created by Malte Bünz on 11.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import XCTest
@testable import CriticalMaps

class MockThemeStore: ThemeStorable {
    
    private var currentTheme: Theme?
    
    func load() -> Theme? {
        guard let theme = currentTheme else {
            return .light
        }
        return theme
    }
    
    func save(_ themeSelection: Theme) {
        self.currentTheme = themeSelection
    }
}

class ThemeStoreTests: XCTestCase {

    var sut: ThemeStorable?
    
    override func setUp() {
        super.setUp()
        sut = MockThemeStore()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testStoreShouldReturnLightThemeWhenNothingIsSavedBefore() {
        // given
        let theme = sut!.load()
        // then
        XCTAssertEqual(theme, .light)
    }
    
    func testStoreShouldReturnDarkThemeWhenDarkIsSavedBefore() {
        // given
        let theme = Theme.dark
        // when
        sut?.save(theme)
        let loadedTheme = sut!.load()
        // then
        XCTAssertEqual(loadedTheme, .dark)
    }
}
