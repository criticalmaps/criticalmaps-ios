//
//  CustomButton.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 2/6/19.
//

import UIKit

class CustomButton: UIButton {
    @objc
    public dynamic var highlightedTintColor: UIColor!
    @objc
    public dynamic var defaultTintColor: UIColor! {
        willSet {
            tintColor = newValue
        }
    }

    override var isHighlighted: Bool {
        didSet {
            tintColor = isHighlighted ? highlightedTintColor : defaultTintColor
        }
    }
}
