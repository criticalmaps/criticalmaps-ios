//
//  ThemeStore.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 10.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

protocol ThemeStore {
    var theme: String? { get set }
}

protocol ThemeStorable {
    func save(_ themeSelection: Theme)
    func load() -> Theme?
}

class ThemeSelectionStore: ThemeStorable {
    private var store: ThemeStore

    init(store: ThemeStore) {
        self.store = store
    }

    /// Save Theme to UserDefaults
    ///
    /// - Parameter themeSelection: The Theme that will be saved.
    func save(_ themeSelection: Theme) {
        store.theme = themeSelection.rawValue
    }

    /// Fetches saved theme from the UserDefaults
    ///
    /// - Returns: Saved theme from a previous session or nil if this is the first start.
    func load() -> Theme? {
        Theme(store.theme)
    }
}
