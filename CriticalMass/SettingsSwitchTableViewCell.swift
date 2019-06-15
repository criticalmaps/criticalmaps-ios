//
//  SettingsSwitchTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/31/19.
//

import UIKit

protocol SettingsSwitchCellConfigurable {
    func configure(isOn: Bool, handler: SettingsSwitchHandler?)
}

typealias SettingsSwitchHandler = (UISwitch) -> Void

class SettingsSwitchTableViewCell: UITableViewCell, SettingsSwitchCellConfigurable, IBConstructable {
    private let switchControl = UISwitch()
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!

    private var switchActionHandler: SettingsSwitchHandler?

    override var textLabel: UILabel? {
        return titleLabel
    }

    override var detailTextLabel: UILabel? {
        subtitleLabel.isHidden = false
        return subtitleLabel
    }

    func configure(isOn: Bool, handler: SettingsSwitchHandler?) {
        switchControl.isOn = isOn
        switchActionHandler = handler
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        subtitleLabel.isHidden = true
        accessoryView = switchControl
        switchControl.addTarget(self, action: #selector(switchControlAction(_:)), for: .valueChanged)
    }

    @objc
    func switchControlAction(_ sender: UISwitch) {
        switchActionHandler?(sender)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        subtitleLabel.isHidden = true
    }
}
