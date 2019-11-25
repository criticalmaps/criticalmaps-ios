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

class ChatInputView: UIView {
    struct Constants {
        static let textFieldHeight = CGFloat(46.0)
        static let sendButtonWidth = CGFloat(65.0)
        static let messageTextFieldInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    @objc
    dynamic var sendMessageButtonColor: UIColor? {
        willSet {
            sendButton.setTitleColor(newValue, for: .normal)
            sendButton.setTitleColor(newValue?.withAlphaComponent(0.4), for: .disabled)
            sendButton.setTitleColor(newValue?.withAlphaComponent(0.4), for: .highlighted)
        }
    }

    @objc
    dynamic var textViewTextColor: UIColor? {
        willSet {
            messageTextField.textColor = newValue
        }
    }

    weak var delegate: ChatInputDelegate?

    private let messageTextField: UITextField = {
        let textField = TextFieldWithInsets()
        textField.isOpaque = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String.chatPlaceholder
        textField.insets = Constants.messageTextFieldInsets
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .send
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = Constants.textFieldHeight / 2.0
        return textField
    }()

    private let sendButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setTitle(String.chatSend, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    private let separator: SeparatorView = {
        let view = SeparatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var chatStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [messageTextField, sendButton])
        view.distribution = .fillProportionally
        view.spacing = 4.0
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
        addSubview(chatStack)
        addSubview(separator)

        messageTextField.addTarget(self, action: #selector(didTapSendButton), for: .editingDidEndOnExit)

        configureConstraints()
    }

    private func configureConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            sendButton.widthAnchor.constraint(equalToConstant: Constants.sendButtonWidth),
            messageTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            chatStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            chatStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            chatStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }

    @objc func didTapSendButton() {
        guard let text = messageTextField.text, text.canBeSent else {
            return
        }
        delegate?.didTapSendButton(text: text)
    }

    public func resetInput() {
        messageTextField.text?.removeAll()
        messageTextField.sendActions(for: .editingChanged)
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        messageTextField.resignFirstResponder()
    }

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            sendButton.isEnabled = text.canBeSent
        }
    }
}

private extension String {
    var canBeSent: Bool {
        !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
