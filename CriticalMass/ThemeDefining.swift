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
    var separatorColor: UIColor { get }
    var cellSelectedBackgroundViewColor: UIColor { get }
    var navigationBarIsTranslucent: Bool { get }
    var placeholderTextColor: UIColor { get }
    var toolBarBackgroundColor: UIColor { get }
    var navigationOverlayBackgroundColor: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var gradientBeginColor: UIColor { get }
    var gradientEndColor: UIColor { get }
    var mapInfoForegroundColor: UIColor { get }
    var mapInfoBackgroundColor: UIColor { get }
    var chatInputBackgroundColor: UIColor { get }
    var settingsPlaceholderColor: UIColor { get }
    var bikeAnnotationBackgroundColor: UIColor { get }
}

struct LightTheme: ThemeDefining {
    var tintColor: UIColor {
        .blue
    }

    var barStyle: UIBarStyle {
        .default
    }

    var keyboardAppearance: UIKeyboardAppearance {
        .default
    }

    var backgroundColor: UIColor {
        .white
    }

    var titleTextColor: UIColor {
        .black
    }

    var secondaryTitleTextColor: UIColor {
        .gray300
    }

    var thirdTitleTextColor: UIColor {
        .gray400
    }

    var switchTintColor: UIColor {
        .black
    }

    var chatMessageInputTextViewBackgroundColor: UIColor {
        .gray500
    }

    var separatorColor: UIColor {
        .lightThemeNavigationOverlaySeperatorColor
    }

    var cellSelectedBackgroundViewColor: UIColor {
        .gray500
    }

    var navigationBarIsTranslucent: Bool {
        false
    }

    var placeholderTextColor: UIColor {
        .gray300
    }

    var toolBarBackgroundColor: UIColor {
        .lightThemeToolBarBackgroundColor
    }

    var navigationOverlayBackgroundColor: UIColor {
        backgroundColor.withAlphaComponent(0.6)
    }

    var statusBarStyle: UIStatusBarStyle {
        .default
    }

    var gradientBeginColor: UIColor {
        .lightThemeGradientBegin
    }

    var gradientEndColor: UIColor {
        .lightThemeGradientEnd
    }

    var chatInputBackgroundColor: UIColor {
        .gray500
    }

    var mapInfoBackgroundColor: UIColor {
        .gray600
    }

    var mapInfoForegroundColor: UIColor {
        .gray200
    }

    var settingsPlaceholderColor: UIColor {
        .lightThemedSettingsPlaceholderColor
    }

    var bikeAnnotationBackgroundColor: UIColor {
        .gray300
    }
}

struct DarkTheme: ThemeDefining {
    var tintColor: UIColor {
        .yellow100
    }

    var barStyle: UIBarStyle {
        .black
    }

    var keyboardAppearance: UIKeyboardAppearance {
        .dark
    }

    var backgroundColor: UIColor {
        .gray200
    }

    var secondaryTitleTextColor: UIColor {
        .gray500
    }

    var thirdTitleTextColor: UIColor {
        .gray400
    }

    var titleTextColor: UIColor {
        .white
    }

    var switchTintColor: UIColor {
        tintColor
    }

    var chatMessageInputTextViewBackgroundColor: UIColor {
        .gray100
    }

    var separatorColor: UIColor {
        .darkThemeNavigationOverlaySeperatorColor
    }

    var cellSelectedBackgroundViewColor: UIColor {
        .gray300
    }

    var navigationBarIsTranslucent: Bool {
        false
    }

    var placeholderTextColor: UIColor {
        .gray500
    }

    var toolBarBackgroundColor: UIColor {
        .black
    }

    var navigationOverlayBackgroundColor: UIColor {
        backgroundColor.withAlphaComponent(0.8)
    }

    var statusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    var gradientBeginColor: UIColor {
        .darkThemeGradientBegin
    }

    var gradientEndColor: UIColor {
        .darkThemeGradientEnd
    }

    var chatInputBackgroundColor: UIColor {
        .gray100
    }

    var mapInfoBackgroundColor: UIColor {
        .gray300
    }

    var mapInfoForegroundColor: UIColor {
        .white
    }

    var settingsPlaceholderColor: UIColor {
        .darkThemedSettingsPlaceholderColor
    }

    var bikeAnnotationBackgroundColor: UIColor {
        .gray500
    }
}
