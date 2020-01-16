//
//  ThemeStore.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 10.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

protocol ThemeStorable {
    func save(_ themeSelection: Theme)
    func load() -> Theme?
}

class ThemeSelectionStore: ThemeStorable {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// Save Theme to UserDefaults
    ///
    /// - Parameter themeSelection: The Theme that will be saved.
    func save(_ themeSelection: Theme) {
        defaults.theme = themeSelection.rawValue
    }

    /// Fetches saved theme from the UserDefaults
    ///
    /// - Returns: Saved theme from a previous session or nil if this is the first start.
    func load() -> Theme? {
        Theme(defaults.theme)
    }
}
