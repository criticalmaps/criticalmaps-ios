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

class ChatInputView: UIView, IBConstructable {
    private enum Constants {
        static let messageTextFieldInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    @objc
    dynamic var sendMessageButtonColor: UIColor? {
        willSet {
            sendButton.tintColor = newValue
        }
    }
    @objc
    dynamic var sendMessageButtonBGColor: UIColor? {
        willSet {
            sendButton.setBackgroundColor(color: .gray,
                                          forState: .disabled)
            sendButton.setBackgroundColor(color: newValue ?? .black,
                                          forState: .normal)
        }
    }
    @objc
    dynamic var textViewTextColor: UIColor? {
        willSet {
            messageTextField.textColor = newValue
        }
    }

    @IBOutlet weak var messageTextField: TextFieldWithInsets! {
        didSet {
            messageTextField.isOpaque = true
            messageTextField.placeholder = String.chatPlaceholder
            messageTextField.insets = Constants.messageTextFieldInsets
            messageTextField.enablesReturnKeyAutomatically = true
            messageTextField.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var sendButton: UIButton!

    weak var delegate: ChatInputDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func resetInput() {
        messageTextField.text?.removeAll()
        messageTextField.sendActions(for: .editingChanged)
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        messageTextField.resignFirstResponder()
    }

    // MARK: - Actions
    @IBAction func didTapSendButton() {
        guard let text = messageTextField.text, text.canBeSent else {
            return
        }
        delegate?.didTapSendButton(text: text)
    }

    @IBAction func editingChanged(_ sender: UITextField) {
        if let text = sender.text {
            sendButton.isEnabled = text.canBeSent
        }
    }
}

private extension String {
    var canBeSent: Bool {
        !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

private extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        let img = renderer.image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        self.setBackgroundImage(img, for: forState)
    }
}
