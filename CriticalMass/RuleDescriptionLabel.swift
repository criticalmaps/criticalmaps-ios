//
//  RuleDescriptionLabel.swift
//  CriticalMapsSnapshotTests
//
//  Created by Felizia Bernutz on 01.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class RuleDescriptionLabel: UILabel {
    @objc
    dynamic var descriptionTextColor: UIColor! {
        willSet { textColor = newValue }
    }

    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    private func configure() {
        numberOfLines = 0
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
    }
}
