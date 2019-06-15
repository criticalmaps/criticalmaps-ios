//
//  SettingsSwitchTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/31/19.
//

import UIKit

protocol Switchable {
    var isEnabled: Bool { get set }
}

class SettingsSwitchTableViewCell: UITableViewCell, IBConstructable {
    private let switchControl = UISwitch()
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!

    private var switchable: Switchable?

    override var textLabel: UILabel? {
        return titleLabel
    }

    override var detailTextLabel: UILabel? {
        subtitleLabel.isHidden = false
        return subtitleLabel
    }

    func configure(switchable: Switchable) {
        switchControl.isOn = switchable.isEnabled
        self.switchable = switchable
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        subtitleLabel.isHidden = true
        accessoryView = switchControl
        switchControl.addTarget(self, action: #selector(switchControlAction(_:)), for: .valueChanged)
    }

    @objc
    func switchControlAction(_ sender: UISwitch) {
        switchable?.isEnabled = sender.isOn
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        subtitleLabel.isHidden = true
    }
}
