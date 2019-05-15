//
//  ThemeStoreTests.swift
//  CriticalMapsTests
//
//  Created by Malte Bünz on 11.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import XCTest

class MockThemeStore: ThemeStorable {
    private var currentTheme: Theme?

    func load() -> Theme? {
        guard let theme = currentTheme else {
            return .light
        }
        return theme
    }

    func save(_ themeSelection: Theme) {
        currentTheme = themeSelection
    }
}

class MockThemeStoreTests: XCTestCase {
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

class ThemeSelectionStoreTests: XCTestCase {
    var sut: ThemeSelectionStore?
    var userdefaults = UserDefaults(suiteName: "CriticalMaps-Tests")!

    override func setUp() {
        super.setUp()
        sut = ThemeSelectionStore(defaults: userdefaults)
    }

    override func tearDown() {
        sut = nil
        userdefaults.removePersistentDomain(forName: "CriticalMaps-Tests")
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
