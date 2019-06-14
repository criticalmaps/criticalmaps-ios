//
//  NoContentMessageLabel.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 12.05.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class NoContentMessageLabel: UILabel {
    @objc
    dynamic var messageTextColor: UIColor! {
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
        textAlignment = .center
        numberOfLines = 0
        font = UIFont.preferredFont(forTextStyle: .body)
    }
}
