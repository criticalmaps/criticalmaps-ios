//
//  SettingsFooterView.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 28.03.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class SettingsFooterView: UITableViewHeaderFooterView, NibInstantiatable {
    /// UIAppearance compatible property
    @objc
    dynamic var versionTextColor: UIColor? { // UI_APPEARANCE_SELECTOR
        didSet { versionNumberLabel.textColor = versionTextColor }
    }

    @objc
    dynamic var buildTextColor: UIColor? { // UI_APPEARANCE_SELECTOR
        didSet { buildNumberLabel.textColor = buildTextColor }
    }

    @IBOutlet var versionNumberLabel: UILabel!
    @IBOutlet var buildNumberLabel: UILabel!
    @IBOutlet private var cmLogoImageView: UIImageView!
}
