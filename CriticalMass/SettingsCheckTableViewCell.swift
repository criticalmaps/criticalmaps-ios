//
// Created for CriticalMaps in 2020

import UIKit

class SettingsCheckTableViewCell: UITableViewCell, IBConstructable {
    private var switchable: Toggleable?

    @objc
    dynamic var titleColor: UIColor? {
        willSet {
            textLabel?.textColor = newValue
        }
    }

    func configure(switchable: Toggleable) {
        accessoryType = switchable.isEnabled ? .checkmark : .none
        self.switchable = switchable
    }
}
