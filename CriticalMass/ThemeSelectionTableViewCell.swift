//
// Created for CriticalMaps in 2020

import UIKit

class ThemeSelectionTableViewCell: UITableViewCell, IBConstructable {
    @objc
    dynamic var titleColor: UIColor? {
        didSet { title.textColor = titleColor }
    }

    @IBOutlet var title: RuleDescriptionLabel!
}
