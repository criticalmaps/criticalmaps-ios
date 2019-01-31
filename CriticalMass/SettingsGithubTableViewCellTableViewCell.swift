//
//  SettingsGithubTableViewCellTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/31/19.
//

import UIKit

class SettingsGithubTableViewCellTableViewCell: UITableViewCell {
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var actionLabel: UILabel!

    @IBOutlet var selectionOverlay: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

        if #available(iOS 10.0, *) {
            titleLabel.adjustsFontForContentSizeCategory = true
            detailLabel.adjustsFontForContentSizeCategory = true
            actionLabel.adjustsFontForContentSizeCategory = true
        }

        titleLabel.text = NSLocalizedString("settings.opensource.title", comment: "")
        titleLabel.textColor = .settingsOpenSourceForeground
        detailLabel.text = NSLocalizedString("settings.opensource.detail", comment: "")
        detailLabel.textColor = .settingsOpenSourceForeground
        actionLabel.text = NSLocalizedString("settings.opensource.action", comment: "")
        actionLabel.textColor = .settingsOpenSourceForeground

        backgroundImageView.image = UIImage(named: "GithubBanner")?.resizableImage(withCapInsets: UIEdgeInsets(top: 20, left: 20, bottom: 200, right: 200), resizingMode: .stretch)
        selectionOverlay.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        selectionOverlay.layer.cornerRadius = 16
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let updateBlock = {
            self.selectionOverlay.alpha = highlighted ? 1 : 0
        }

        if animated {
            UIView.animate(withDuration: 0.2, animations: updateBlock)
        } else {
            updateBlock()
        }
    }
}
