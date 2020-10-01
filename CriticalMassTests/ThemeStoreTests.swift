//
//  ThemeStoreTests.swift
//  CriticalMapsTests
//
//  Created by Malte Bünz on 11.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import XCTest

class ThemeSelectionStoreTests: XCTestCase {
    private var sut: ThemeSelectionStore?
    private var store: ThemeStore!

    override func setUp() {
        super.setUp()
        store = ThemeStoreMock()
        sut = ThemeSelectionStore(store: store)
    }

    override func tearDown() {
        sut = nil
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

private struct ThemeStoreMock: ThemeStore {
    var theme: String?
}
