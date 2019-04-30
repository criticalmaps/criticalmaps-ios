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
    var tintColor: UIColor { get }
    var barStyle: UIBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    var backgroundColor: UIColor { get }
    var titleTextColor: UIColor { get }
    var secondaryTitleTextColor: UIColor { get }
    var switchTintColor: UIColor { get }
    var chatMessageInputTextViewBackgroundColor: UIColor { get }
    var navigationOverlaySeperatorColor: UIColor { get }
    var cellSelectedBackgroundViewColor: UIColor { get }
    var navigationBarIsTranslucent: Bool { get }
    var placeholderTextColor: UIColor { get }
}

struct LightTheme: ThemeDefining {
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

    var titleTextColor: UIColor {
        return .black
    }

    var secondaryTitleTextColor: UIColor {
        return .gray500
    }

    var switchTintColor: UIColor {
        return .black
    }

    var chatMessageInputTextViewBackgroundColor: UIColor {
        return .gray500
    }

    var navigationOverlaySeperatorColor: UIColor {
        return UIColor(red: 0.86, green: 0.88, blue: 0.85, alpha: 1.00)
    }

    var cellSelectedBackgroundViewColor: UIColor {
        return .gray500
    }

    var navigationBarIsTranslucent: Bool {
        return true
    }

    var placeholderTextColor: UIColor {
        return .gray300
    }
}

struct DarkTheme: ThemeDefining {
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

    var secondaryTitleTextColor: UIColor {
        return .gray500
    }

    var titleTextColor: UIColor {
        return .white
    }

    var switchTintColor: UIColor {
        return tintColor
    }

    var chatMessageInputTextViewBackgroundColor: UIColor {
        return .gray100
    }

    var navigationOverlaySeperatorColor: UIColor {
        return UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.00)
    }

    var cellSelectedBackgroundViewColor: UIColor {
        return .gray300
    }

    var navigationBarIsTranslucent: Bool {
        return false
    }

    var placeholderTextColor: UIColor {
        return .gray500
    }
}
