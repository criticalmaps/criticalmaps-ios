//
//  CustomButton.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 2/6/19.
//

import UIKit

class CustomButton: UIButton {
    @objc
    public dynamic var highlightedTintColor: UIColor?
    private var defaultTintColor: UIColor?

    override var isHighlighted: Bool {
        didSet {
            if let highlightedTintColor = highlightedTintColor, isHighlighted {
                if defaultTintColor == nil {
                    defaultTintColor = tintColor
                }
                tintColor = highlightedTintColor
            } else if let defaultTintColor = defaultTintColor {
                tintColor = defaultTintColor
                self.defaultTintColor = nil
            }
        }
    }
}
