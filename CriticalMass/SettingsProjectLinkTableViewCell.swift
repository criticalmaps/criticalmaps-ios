//
//  SettingsGithubTableViewCellTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/31/19.
//

import UIKit

class SettingsProjectLinkTableViewCell: UITableViewCell, IBConstructable {
    @IBOutlet var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.layer.cornerRadius = 16.0
        }
    }

    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.scalableSystemFont(fontSize: 20.0, weight: .heavy)
            titleLabel.textColor = .settingsOpenSourceForeground
        }
    }

    @IBOutlet var detailLabel: UILabel! {
        didSet {
            detailLabel.textColor = .settingsOpenSourceForeground
            detailLabel.font = UIFont.scalableSystemFont(fontSize: 15.0, weight: .medium)
        }
    }

    @IBOutlet var actionLabel: UILabel! {
        didSet {
            actionLabel.textColor = .settingsOpenSourceForeground
            actionLabel.font = UIFont.scalableSystemFont(fontSize: 15.0, weight: .bold)
        }
    }

    @IBOutlet var selectionOverlay: UIView! {
        didSet {
            selectionOverlay.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            selectionOverlay.layer.cornerRadius = 16
        }
    }

    @IBOutlet var arrowImageView: UIImageView! {
        didSet {
            arrowImageView.tintColor = .settingsOpenSourceForeground
        }
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

extension SettingsProjectLinkTableViewCell {
    struct CellConfiguration {
        let title: String
        let detail: String
        let actionTitle: String
        let image: UIImage

        static let github = CellConfiguration(
            title: L10n.settingsOpenSourceTitle,
            detail: L10n.settingsOpenSourceDetail,
            actionTitle: L10n.settingsOpenSourceAction.uppercased(),
            image: UIImage(named: "GithubBanner")!
        )

        static let criticalMassDotIn = CellConfiguration(
            title: L10n.settingsCriticalMassDotInTitle,
            detail: L10n.settingsCriticalMassDotInDetail,
            actionTitle: L10n.settingsCriticalMassDotInAction.uppercased(),
            image: UIImage(named: "banner cm")!
        )
    }
}
