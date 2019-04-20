//
//  SettingsSwitchTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/31/19.
//

import UIKit

protocol SettingsSwitchCellConfigurable {
    func configure(isOn: Bool, selector: Selector)
}

class SettingsSwitchTableViewCell: UITableViewCell, SettingsSwitchCellConfigurable, NibProviding {
    
    private let switchControl = UISwitch()
    @IBOutlet var titleLabel: UILabel!

    override var textLabel: UILabel? {
        return titleLabel
    }

    func configure(isOn: Bool, selector: Selector) {
        switchControl.isOn = isOn
        switchControl.addTarget(nil, action: selector, for: .valueChanged)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryView = switchControl
    }
}
