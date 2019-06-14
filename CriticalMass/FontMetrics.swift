//
//  DynamicTypeHelper.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 29.05.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation
import UIKit

/// A `UIFontMetrics` wrapper, allowing iOS 11 devices to take advantage of `UIFontMetrics` scaling,
/// while earlier iOS versions fall back on a scale calculation.
///
enum FontMetrics {
    /// A scale value based on the current device text size setting. With the device using the
    /// default Large setting, `scaler` will be `1.0`. Only used when `UIFontMetrics` is not
    /// available.
    ///
    static var scaler: CGFloat {
        return UIFont.preferredFont(forTextStyle: .body).pointSize / 17.0
    }

    /// Returns a version of the specified font that adopts the current font metrics.
    ///
    /// - Parameter font: A font at its default point size.
    /// - Returns: The font at its scaled point size.
    ///
    static func scaledFont(for font: UIFont) -> UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: font)
        } else {
            return font.withSize(scaler * font.pointSize)
        }
    }

    /// Returns a version of the specified font that adopts the current font metrics and is
    /// constrained to the specified maximum size.
    ///
    /// - Parameters:
    ///   - font: A font at its default point size.
    ///   - maximumPointSize: The maximum point size to scale up to.
    /// - Returns: The font at its constrained scaled point size.
    ///
    static func scaledFont(for font: UIFont, maximumPointSize: CGFloat) -> UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: font,
                                                    maximumPointSize: maximumPointSize,
                                                    compatibleWith: nil)
        } else {
            return font.withSize(min(scaler * font.pointSize, maximumPointSize))
        }
    }
}
