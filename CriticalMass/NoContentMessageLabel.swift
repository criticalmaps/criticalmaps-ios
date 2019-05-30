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

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    private func configure() {
        textAlignment = .center
        numberOfLines = 0
        font = UIFont.scalableSystemFont(fontSize: 17, weight: .regular)
    }
}
