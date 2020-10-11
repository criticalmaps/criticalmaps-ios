//
//  Theme.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 10.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

enum Theme: String, CaseIterable {
    case system
    case light
    case dark

    init(userInterfaceStyle: UIUserInterfaceStyle) {
        switch userInterfaceStyle {
        case .dark, .light:
            self = .system
        case .unspecified:
            self = .light
        @unknown default:
            self = .light
        }
    }

    var style: ThemeDefining {
        switch self {
        case .system:
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    return DarkTheme()
                }
            }
            return LightTheme()
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        }
    }
}

extension Theme {
    init?(_ themeString: String?) {
        guard let theme = themeString?.lowercased() else { return nil }
        switch theme {
        case "system": self = .system
        case "light": self = .light
        case "dark": self = .dark
        default: return nil
        }
    }

    var displayName: String {
        switch self {
        case .system:
            return L10n.Settings.Theme.system
        case .light:
            return L10n.Settings.Theme.light
        case .dark:
            return L10n.Settings.Theme.dark
        }
    }
}
