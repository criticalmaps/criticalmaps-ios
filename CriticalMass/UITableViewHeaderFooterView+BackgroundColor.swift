//
//  UITableViewHeaderFooterView+BackgroundColor.swift
//  CriticalMaps
//
//  Created by MAXIM TSVETKOV on 03.10.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

extension UITableViewHeaderFooterView {
    override open var backgroundColor: UIColor? {
        get {
            customBackgroundView.backgroundColor
        }
        set {
            customBackgroundView.backgroundColor = newValue
        }
    }

    private var customBackgroundView: UIView {
        guard let backgroundView = self.backgroundView else {
            let customView = UIView()
            self.backgroundView = customView
            return customView
        }
        return backgroundView
    }
}
