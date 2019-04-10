//
//  ThemeDefining.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 10.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit
import Foundation

protocol ThemeDefining {
    var name: String { get }
    var tintColor: UIColor { get }
    var barStyle: UIBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    var backgroundColor: UIColor { get }
    var secondaryBackgroundColor: UIColor { get }
    var negativeBackgroundColor: UIColor { get }
    var titleTextColor: UIColor { get }
}

struct LightTheme: ThemeDefining {
    var name: String {
        return NSLocalizedString("settings.theme.light", comment: "")
    }
    var tintColor: UIColor {
        return .purple
    }
    var barStyle: UIBarStyle {
        return .default
    }
    var keyboardAppearance: UIKeyboardAppearance {
        return .default
    }
    var backgroundColor: UIColor {
        return .purple
    }
    var secondaryBackgroundColor: UIColor {
        return .white
    }
    var negativeBackgroundColor: UIColor {
        return .blue
    }
    var titleTextColor: UIColor {
        return .white
    }
}

struct DarkTheme: ThemeDefining {
    var name: String {
        return NSLocalizedString("settings.theme.dark", comment: "")
    }
    var tintColor: UIColor {
        return .yellow100
    }
    var barStyle: UIBarStyle {
        return .black
    }
    var keyboardAppearance: UIKeyboardAppearance {
        return .dark
    }
    var backgroundColor: UIColor {
        return .gray200
    }
    var secondaryBackgroundColor: UIColor {
        return .black
    }
    var negativeBackgroundColor: UIColor {
        return .white
    }
    var titleTextColor: UIColor {
        return .white
    }
}
