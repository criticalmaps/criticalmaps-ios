//
//  UIFont+Scalable.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 30.05.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

extension UIFont {
    /// Creates a System Font that is reacting to Font size changes from the OS.
    ///
    /// - Parameters:
    ///   - fontSize: Initial font size.
    ///   - weight: UIFont.Weight of the font.
    /// - Returns: UIFont of Font SystemFont that is reacting to Dynamic Type changes.
    static func scalableSystemFont(fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        return FontMetrics.scaledFont(for: font)
    }

    /// Creates a System Font that is reacting to Font size changes from the OS.
    ///
    /// - Parameters:
    ///   - fontSize: Initial font size.
    ///   - weight: UIFont.Weight of the font.
    ///   - maxPointSize: Sets the maximim point size the font can have.
    /// - Returns: UIFont of Font SystemFont that is reacting to Dynamic Type changes.
    static func scalableSystemFont(fontSize: CGFloat, weight: UIFont.Weight, maxPointSize: CGFloat) -> UIFont {
        let font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        return FontMetrics.scaledFont(for: font, maximumPointSize: maxPointSize)
    }
}
