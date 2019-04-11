//
//  ThemeController.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 09.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation
import UIKit

class ThemeController {
    
    private(set) lazy var currentTheme = loadTheme()
    private let store: ThemeStorable
    
    static let shared = ThemeController()
    
    private init() {
        self.store = ThemeSelectionStore()
    }
    
    func changeTheme(to theme: Theme) {
        currentTheme = theme
        store.save(currentTheme)
    }
    
    private func loadTheme() -> Theme {
        guard let theme = store.load() else {
            return .light
        }
        return theme
    }
    
    func applyTheme() {
        let theme = currentTheme.style
        UIApplication.shared.delegate?.window??.tintColor = theme.backgroundColor
        UISegmentedControl.appearance().tintColor = theme.tintColor
        // NavigationBar
        UINavigationBar.appearance().barTintColor = theme.backgroundColor
        UINavigationBar.appearance().tintColor = theme.tintColor
    }
}
