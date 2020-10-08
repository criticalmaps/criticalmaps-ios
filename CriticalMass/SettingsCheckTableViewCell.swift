//
// Created for CriticalMaps in 2020

import UIKit

class SettingsCheckTableViewCell: UITableViewCell, IBConstructable {
    @objc
    dynamic var titleColor: UIColor? {
        willSet {
            textLabel?.textColor = newValue
        }
    }
}
