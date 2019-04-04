//
//  SettingsFooterView.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 28.03.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class SettingsFooterView: UITableViewHeaderFooterView, NibInstantiatable {

    @IBOutlet weak var versionNumberLabel: UILabel! {
        didSet {
            versionNumberLabel.textColor = .gray200
        }
    }
    @IBOutlet weak var buildNumberLabel: UILabel! {
        didSet {
            buildNumberLabel.textColor = .gray400
        }
    }
    @IBOutlet private weak var cmLogoImageView: UIImageView!
}
