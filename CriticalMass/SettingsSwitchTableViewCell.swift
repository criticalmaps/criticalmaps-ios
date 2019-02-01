//
//  SettingsSwitchTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/31/19.
//

import UIKit

class SettingsSwitchTableViewCell: UITableViewCell {
    private let switchControl = UISwitch()

    @IBOutlet var titleLabel: UILabel!

    override var textLabel: UILabel? {
        return titleLabel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .settingsForeground
        accessoryView = switchControl
        // we currently only use SettingsSwitchTableViewCell for the GPS switch. We should move the code to the model once we introduce more preferences that might use this cell
        switchControl.isOn = Preferences.gpsEnabled
        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }

    @objc private func switchValueChanged() {
        Preferences.gpsEnabled = switchControl.isOn
    }
}
