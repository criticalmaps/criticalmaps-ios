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
    private let defaultsKey = "theme"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// Save Theme to UserDefaults
    ///
    /// - Parameter themeSelection: The Theme that will be saved.
    func save(_ themeSelection: Theme) {
        defaults.set(themeSelection.rawValue, forKey: defaultsKey)
    }

    /// Fetches saved theme from the UserDefaults
    ///
    /// - Returns: Saved Theme from a previous session.
    func load() -> Theme? {
        guard let storedTheme = defaults.object(forKey: defaultsKey) as? Int else {
            return nil
        }
        return Theme(rawValue: storedTheme)
    }
}
