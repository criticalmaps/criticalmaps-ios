//
//  MapInfoView.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 13.12.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class MapInfoView: UIView, IBConstructable {
    struct Configuration {
        enum Style: String {
            case alert
            case info
        }

        var title: String
        var style: Style
    }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!

    @objc
    dynamic var mapInfoForegroundColor: UIColor = .black {
        didSet {
            updateStyle()
        }
    }

    @objc
    dynamic var mapInfoBackgroundColor: UIColor = .white {
        didSet {
            updateStyle()
        }
    }

    private var configuration: Configuration?

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 18
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)

        label.isAccessibilityElement = false
        label.adjustsFontForContentSizeCategory = true
    }

    func configure(with configuration: Configuration) {
        self.configuration = configuration
        label.text = configuration.title

        imageView.image = UIImage(named: configuration.style.rawValue)

        accessibilityValue = configuration.title
        updateStyle()
    }

    private func updateStyle() {
        guard let configuration = configuration else {
            return
        }
        let foregroundColor: UIColor
        switch configuration.style {
        case .alert:
            foregroundColor = .white
            backgroundColor = .errorRed
            accessibilityLabel = String.error
        case .info:
            foregroundColor = mapInfoForegroundColor
            backgroundColor = mapInfoBackgroundColor
            accessibilityLabel = ""
        }
        imageView.tintColor = foregroundColor
        label.textColor = foregroundColor
    }
}
