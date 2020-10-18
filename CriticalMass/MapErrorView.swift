//
// Created for CriticalMaps in 2020

import UIKit

final class MapErrorView: UIView, IBConstructable {
    @IBOutlet private var stackView: UIVisualEffectView! {
        didSet {
            stackView.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(toggleErrorLabelVisibility)
                )
            )
        }
    }

    @IBOutlet private var errorLabel: UILabel! {
        didSet {
            errorLabel.isHidden = true
        }
    }

    @IBOutlet private var errorIconView: UIImageView!

    func setErrorLabelMessage(_ message: String) {
        errorLabel.text = message
    }

    @objc func toggleErrorLabelVisibility(_: Selector) {
        UIView.animate(withDuration: 0.2) {
            self.errorLabel.isHidden.toggle()
        }
    }
}
