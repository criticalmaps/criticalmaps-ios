//
//  UIView+Nib.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 28.03.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

protocol NibInstantiatable {
    static func nibName() -> String
}

extension NibInstantiatable {
    static func nibName() -> String {
        return String(describing: self)
    }
}

extension NibInstantiatable where Self: UIView {
    @discardableResult
    static func fromNib() -> Self? {
        let bundle = Bundle(for: self)
        let nib = bundle.loadNibNamed(nibName(), owner: self, options: nil)
        return nib?.first as? Self
    }
}
