//
//  SnapshotTester.swift
//  CriticalMapsSnapshotTests
//
//  Created by MAXIM TSVETKOV on 05.10.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps

class MockThemeController: ThemeController {
    static let shared = MockThemeController()

    private init() {
        let store = MockThemeStore()
        super.init(store: store)
    }
}

class MockThemeStore: ThemeStorable {
    private var currentTheme: Theme?

    func load() -> Theme? {
        currentTheme
    }

    func save(_ themeSelection: Theme) {
        currentTheme = themeSelection
    }
}
