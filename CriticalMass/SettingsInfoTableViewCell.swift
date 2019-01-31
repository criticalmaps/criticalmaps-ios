//
//  SettingsInfoTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/31/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class SettingsInfoTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.textColor = .settingsForeground
    }
}
