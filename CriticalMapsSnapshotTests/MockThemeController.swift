//
//  SnapshotTester.swift
//  CriticalMapsSnapshotTests
//
//  Created by MAXIM TSVETKOV on 05.10.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import SnapshotTesting
import XCTest

class MockThemeController: ThemeController {
    static let shared = MockThemeController()
    
    private init() {
        let store = MockThemeStore()
        super.init(store: store)
    }
}

//TODO: move MockThemeStore class to shared file for both CriticalMassTests and CriticalMapsSnapshotTests targets
class MockThemeStore: ThemeStorable {
    private var currentTheme: Theme?

    func load() -> Theme? {
        return currentTheme
    }

    func save(_ themeSelection: Theme) {
        currentTheme = themeSelection
    }
}
