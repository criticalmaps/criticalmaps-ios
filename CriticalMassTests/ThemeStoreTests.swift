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
        return currentTheme
    }

    func save(_ themeSelection: Theme) {
        currentTheme = themeSelection
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

    func testStoreShouldReturnNilThemeWhenNothingIsSavedBefore() {
        // given
        let theme = sut!.load()
        // then
        XCTAssertNil(theme)
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
