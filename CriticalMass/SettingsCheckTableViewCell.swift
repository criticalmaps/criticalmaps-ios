//
// Created for CriticalMaps in 2020

import UIKit

class SettingsCheckTableViewCell: UITableViewCell, IBConstructable {
    private var switchable: Toggleable?

    func configure(switchable: Toggleable) {
        accessoryType = switchable.isEnabled ? .checkmark : .none
        self.switchable = switchable
    }
}
