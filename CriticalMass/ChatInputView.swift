//
//  ChatInputView.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/25/19.
//

import UIKit

protocol ChatInputDelegate: AnyObject {
    func didTapSendButton(text: String)
}

class ChatInputView: UIView, UITextFieldDelegate {
    @objc
    dynamic var sendMessageButtonColor: UIColor? {
        willSet {
            button.setTitleColor(newValue, for: .normal)
            button.setTitleColor(newValue?.withAlphaComponent(0.4), for: .disabled)
            button.setTitleColor(newValue?.withAlphaComponent(0.4), for: .highlighted)
        }
    }

    @objc
    dynamic var textViewTextColor: UIColor? {
        willSet {
            textField.textColor = newValue
        }
    }

    weak var delegate: ChatInputDelegate?

    private let textField: UITextField = {
        let textField = TextFieldWithInsets()
        textField.isOpaque = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = NSLocalizedString("chat.placeholder", comment: "")
        textField.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .send
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.layer.masksToBounds = true
        return textField
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setTitle(NSLocalizedString("chat.send", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    private let separator: SeperatorView = {
        let view = SeperatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addSubview(textField)
        addSubview(button)
        addSubview(separator)

        textField.delegate = self

        configureConstraints()
    }

    private func configureConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 9),
            NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textField, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.7, constant: -8),
            NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.3, constant: 0),
            NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 9),
            NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: separator, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1),
            NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: separator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textField.layer.cornerRadius = textField.frame.height / 2
    }

    @objc func didTapSendButton() {
        delegate?.didTapSendButton(text: textField.text ?? "")
    }

    public func resetInput() {
        textField.text = ""
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            button.isEnabled = !text.isEmpty
        }
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text ?? "") != "" {
            didTapSendButton()
            return true
        }
        return false
    }
}
