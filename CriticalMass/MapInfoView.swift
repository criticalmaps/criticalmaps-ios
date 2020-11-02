//
//  MapInfoView.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 13.12.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class MapInfoView: UIView, IBConstructable {
    typealias TapHandler = (() -> Void)
    struct Configuration {
        enum Style: String {
            case alert
            case info

            var icon: UIImage {
                switch self {
                case .alert:
                    return Asset.alert.image
                case .info:
                    return Asset.info.image
                }
            }
        }

        var title: String
        var style: Style

        var isCloseButtonHidden: Bool {
            switch style {
            case .alert: return true
            case .info: return false
            }
        }
    }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!
    @IBOutlet private var closeButton: UIButton!

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

    /// Closure to be executed view was tapped
    var tapHandler: TapHandler?
    /// Closure to be executed when close button was tapped
    var closeButtonHandler: TapHandler?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func configure(with configuration: Configuration) {
        self.configuration = configuration
        label.text = configuration.title
        imageView.image = configuration.style.icon
        closeButton.isHidden = configuration.isCloseButtonHidden
        accessibilityValue = configuration.title
        if case .info = configuration.style {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
        }
        updateStyle()
    }

    private func setup() {
        layer.setupMapOverlayConfiguration(cornerRadius: 12)
        label.isAccessibilityElement = false
        label.adjustsFontForContentSizeCategory = true
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
            accessibilityLabel = L10n.error
        case .info:
            foregroundColor = mapInfoForegroundColor
            backgroundColor = mapInfoBackgroundColor
            accessibilityLabel = ""
        }
        imageView.tintColor = foregroundColor
        label.textColor = foregroundColor
        closeButton.tintColor = foregroundColor
    }

    @objc private func didTap(_: UITapGestureRecognizer) {
        tapHandler?()
    }

    @IBAction private func didTapCloseButton(_: Any) {
        closeButtonHandler?()
    }
}
