//
//  ThemeDefining.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 10.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation
import UIKit

protocol ThemeDefining {
    var name: String { get }
    var tintColor: UIColor { get }
    var barStyle: UIBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    var backgroundColor: UIColor { get }
    var secondaryBackgroundColor: UIColor { get }
    var negativeBackgroundColor: UIColor { get }
    var titleTextColor: UIColor { get }
    var secondaryTitleTextColor: UIColor { get }
    var switchTintColor: UIColor { get }
    var refreshControlColor: UIColor { get }
    var chatMessageInputTextViewBackgroundColor: UIColor { get }
    var navigationOverlaySeperatorColor: UIColor { get }
}

struct LightTheme: ThemeDefining {
    var name: String {
        return NSLocalizedString("settings.theme.light", comment: "")
    }

    var tintColor: UIColor {
        return .blue
    }

    var barStyle: UIBarStyle {
        return .default
    }

    var keyboardAppearance: UIKeyboardAppearance {
        return .default
    }

    var backgroundColor: UIColor {
        return .white
    }

    var secondaryBackgroundColor: UIColor {
        return .white
    }

    var negativeBackgroundColor: UIColor {
        return .blue
    }

    var titleTextColor: UIColor {
        return .black
    }

    var secondaryTitleTextColor: UIColor {
        return .gray500
    }

    var switchTintColor: UIColor {
        return UIColor(red: 0.30, green: 0.85, blue: 0.39, alpha: 1.00)
    }

    var refreshControlColor: UIColor {
        return .black
    }

    var chatMessageInputTextViewBackgroundColor: UIColor {
        return .gray100
    }

    var navigationOverlaySeperatorColor: UIColor {
        return UIColor(red: 0.86, green: 0.88, blue: 0.85, alpha: 1.00)
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

    var secondaryTitleTextColor: UIColor {
        return .gray500
    }

    var negativeBackgroundColor: UIColor {
        return .white
    }

    var titleTextColor: UIColor {
        return .white
    }

    var switchTintColor: UIColor {
        return tintColor
    }

    var refreshControlColor: UIColor {
        return .yellow100
    }

    var chatMessageInputTextViewBackgroundColor: UIColor {
        return .gray100
    }

    var navigationOverlaySeperatorColor: UIColor {
        return UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.00)
    }
}
