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
    
    init(store: ThemeStorable = ThemeSelectionStore()) {
        self.store = store
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
        UIApplication.shared.delegate?.window??.tintColor = theme.tintColor
        UITextField.appearance().keyboardAppearance = theme.keyboardAppearance
        // NavigationBar
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().tintColor = theme.titleTextColor
        // UISegmentedControl
        UISegmentedControl.appearance().backgroundColor = theme.backgroundColor
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UIToolbar.self]).tintColor = theme.titleTextColor
        // UISwitch
        UISwitch.appearance().onTintColor = theme.switchTintColor // Settings switches
        TweetTableViewCell.appearance().linkTintColor = theme.tintColor
        NotificationCenter.default.post(name: NSNotification.themeDidChange, object: nil) // trigger map tileRenderer update
        
        UIApplication.shared.refreshAppearance(animated: false)
    }
}
