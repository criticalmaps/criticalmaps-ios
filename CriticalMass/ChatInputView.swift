//
//  ChatInputView.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/25/19.
//

import UIKit

protocol ChatInputDelegate: class {
    func didTapSendButton(text: String)
}

class ChatInputView: UIView {
    weak var delegate: ChatInputDelegate?

    private let textField: UITextField = {
        let textField = TextFieldWithInsets()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .chatInputTextfieldBackground
        textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("chat.placeholder", comment: ""), attributes: [.foregroundColor: UIColor.chatInputPlaceholder])
        textField.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return textField
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setTitle(NSLocalizedString("chat.send", comment: ""), for: .normal)
        button.setTitleColor(.chatInputSendButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .chatInputSeparator
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
        backgroundColor = .chatInputBackground
        addSubview(textField)
        addSubview(button)
        addSubview(separator)

        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        configureConstraints()
    }

    private func configureConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: -18),
            NSLayoutConstraint(item: textField, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textField, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.7, constant: -8),
            NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.3, constant: 0),
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: -18),
            NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
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
}
