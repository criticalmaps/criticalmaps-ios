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
        }

        var title: String
        var style: Style
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

        imageView.image = UIImage(named: configuration.style.rawValue)

        accessibilityValue = configuration.title
        updateStyle()

    }
    
    private func setup() {
        layer.setupMapOverlayConfiguration()
        label.isAccessibilityElement = false
        label.adjustsFontForContentSizeCategory = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
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
        closeButton.tintColor = foregroundColor
    }

    @objc private func didTap(_: UITapGestureRecognizer) {
        tapHandler?()
    }

    @IBAction private func didTapCloseButton(_: Any) {
        closeButtonHandler?()
    }
}
