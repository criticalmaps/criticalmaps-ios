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
    var thirdTitleTextColor: UIColor { get }
    var secondaryTitleTextColor: UIColor { get }
    var switchTintColor: UIColor { get }
    var chatMessageInputTextViewBackgroundColor: UIColor { get }
    var navigationOverlaySeperatorColor: UIColor { get }
    var cellSelectedBackgroundViewColor: UIColor { get }
    var navigationBarIsTranslucent: Bool { get }
    var placeholderTextColor: UIColor { get }
    var toolBarBackgroundColor: UIColor { get }
    var navigationOverlayBackgroundColor: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
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
        return .gray300
    }

    var thirdTitleTextColor: UIColor {
        return .gray400
    }

    var switchTintColor: UIColor {
        return .black
    }

    var chatMessageInputTextViewBackgroundColor: UIColor {
        return .gray500
    }

    var navigationOverlaySeperatorColor: UIColor {
        return .lightThemeNavigationOverlaySeperatorColor
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

    var toolBarBackgroundColor: UIColor {
        return .lightThemeToolBarBackgroundColor
    }

    var navigationOverlayBackgroundColor: UIColor {
        return backgroundColor.withAlphaComponent(0.6)
    }

    var statusBarStyle: UIStatusBarStyle {
        return .default
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

    var thirdTitleTextColor: UIColor {
        return .gray400
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
        return .darkThemeNavigationOverlaySeperatorColor
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

    var toolBarBackgroundColor: UIColor {
        return .black
    }

    var navigationOverlayBackgroundColor: UIColor {
        return backgroundColor.withAlphaComponent(0.8)
    }

    var statusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
