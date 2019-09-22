//
//  TextFieldWithInsets.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import UIKit

/// extension to colorize all subviews except the placeholderView
private extension UITextField {
    func setEditorBackgroundColor(to color: UIColor?) {
        subviews.forEach { view in
            if view is UILabel {
                return
            }
            view.backgroundColor = color
        }
    }

    var placeholderColor: UIColor {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }
}

class TextFieldWithInsets: UITextField {
    var insets: UIEdgeInsets = .zero

    @objc
    dynamic var textFieldBackgroundColor: UIColor? {
        willSet {
            backgroundColor = newValue
        }
    }

    @objc
    dynamic var placeholderTextColor: UIColor! {
        didSet {
            placeholderColor = placeholderTextColor
        }
    }

    // sets the backgroundColor when input begins
    // kind of a hack sice the textField was always resetting its backgrundColor when it became firstResponder
    override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        if didBecomeFirstResponder {
            setEditorBackgroundColor(to: textFieldBackgroundColor)
        }
        return didBecomeFirstResponder
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}
