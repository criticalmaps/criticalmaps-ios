//
//  SettingsSwitchTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/31/19.
//

import UIKit

protocol Toggleable {
    var isEnabled: Bool { get set }
}

class SettingsSwitchTableViewCell: UITableViewCell, IBConstructable {
    @objc
    dynamic var titleColor: UIColor? {
        willSet {
            titleLabel.textColor = newValue
        }
    }

    @objc
    dynamic var subtitleColor: UIColor? {
        willSet {
            subtitleLabel.textColor = newValue
        }
    }

    var actionCallBack: ((Bool) -> Void)?
    var switchControl = UISwitch()
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!

    private var switchable: Toggleable? // TODO: Remove because this makes the view model aware

    override var textLabel: UILabel? {
        titleLabel
    }

    override var detailTextLabel: UILabel? {
        subtitleLabel.isHidden = false
        return subtitleLabel
    }

    func configure(switchable: Toggleable) {
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
        actionCallBack?(sender.isOn)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        subtitleLabel.isHidden = true
    }
}
