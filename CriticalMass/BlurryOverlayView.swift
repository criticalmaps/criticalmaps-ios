//
//  BlurryOverlayView.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 13.06.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    override func awakeFromNib() {
        configureUI()
    }

    override func prepareForInterfaceBuilder() {
        configureUI()
    }

    private func configureUI() {
        setTitleColor(.black, for: .normal)
        backgroundColor = .yellow100
        layer.cornerRadius = 24
        titleLabel?.font = UIFont.scalableSystemFont(fontSize: 17, weight: .bold)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
}

class BlurryOverlayView: UIView, IBConstructable {
    @objc
    dynamic var gradientBeginColor: UIColor = .black {
        didSet {
            updateGradient()
        }
    }

    @objc
    dynamic var gradientEndColor: UIColor = .white {
        didSet {
            updateGradient()
        }
    }

    @IBOutlet private var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private var settingsButton: RoundedButton!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var titlelabel: UILabel!

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func awakeFromNib() {
        updateGradient()
        settingsButton.accessibilityIdentifier = "SettingsButton"
    }

    public func set(title: String, message: String) {
        titlelabel.text = title
        messageLabel.text = message
    }

    public func addButtonTarget(_ taget: Any?, action: Selector) {
        settingsButton.addTarget(taget, action: action, for: .touchUpInside)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            titleLabelTopConstraint.constant = 54 + (window?.safeAreaInsets.top ?? 0)
        }
    }

    private func updateGradient() {
        guard let gradientLayer = self.layer as? CAGradientLayer else {
            return
        }

        gradientLayer.colors = [gradientBeginColor.cgColor, gradientEndColor.cgColor]
    }
}
