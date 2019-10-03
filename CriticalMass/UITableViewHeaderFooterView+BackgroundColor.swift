//
//  UITableViewHeaderFooterView+BackgroundColor.swift
//  CriticalMaps
//
//  Created by MAXIM TSVETKOV on 03.10.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

extension UITableViewHeaderFooterView {
    open override var backgroundColor: UIColor? {
        get {
            return backgroundView?.backgroundColor
        }
        set {
            backgroundView?.backgroundColor = newValue
        }
    }
}
