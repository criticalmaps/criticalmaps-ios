//
// Created for CriticalMaps in 2020

import UIKit

class AppIconTableViewCell: UITableViewCell, IBConstructable {
    @objc
    dynamic var titleColor: UIColor? {
        didSet { title.textColor = titleColor }
    }

    @IBOutlet var iconPreview: UIImageView! {
        didSet {
            iconPreview.layer.cornerRadius = 8.0
            iconPreview.clipsToBounds = true
        }
    }

    @IBOutlet var title: RuleDescriptionLabel!
}
