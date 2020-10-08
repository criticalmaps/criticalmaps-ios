//
// Created for CriticalMaps in 2020

import UIKit

protocol Selectable {
    func configure(isSelected: Bool)
}

extension UITableViewCell: Selectable {
    func configure(isSelected: Bool) {
        if #available(iOS 13.0, *) {
            let checkmarkIcon = UIImage(systemName: "checkmark.circle")!
            let checkmarkIconView = UIImageView(image: checkmarkIcon)
            checkmarkIconView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            accessoryView = isSelected ? checkmarkIconView : nil
        } else {
            accessoryType = isSelected ? .checkmark : .none
        }
    }
}
