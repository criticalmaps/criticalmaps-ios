//
//  UIView+Additions.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 04.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
