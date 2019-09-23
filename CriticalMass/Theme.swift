//
//  Theme.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 10.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

enum Theme: Int {
    case light
    case dark

    @available(iOS 12.0, *)
    init(userInterfaceStyle: UIUserInterfaceStyle) {
        switch userInterfaceStyle {
        case .dark:
            self = .dark
        case .light, .unspecified:
            self = .light
        @unknown default:
            self = .light
        }
    }

    var style: ThemeDefining {
        switch self {
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        }
    }
}
