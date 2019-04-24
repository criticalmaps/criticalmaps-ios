//
//  TextFieldWithInsets.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import UIKit

private extension UITextField {
    func setEditorBackgroundColor(to color: UIColor?) {
        subviews.forEach { view in
            view.backgroundColor = color
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

    override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        if didBecomeFirstResponder {
            setEditorBackgroundColor(to: textFieldBackgroundColor)
        }
        return didBecomeFirstResponder
    }

    override func resignFirstResponder() -> Bool {
        let canBecomeFirstResponder = super.canBecomeFirstResponder
        if canBecomeFirstResponder {
            setEditorBackgroundColor(to: textFieldBackgroundColor)
        }
        return canBecomeFirstResponder
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
