//
//  ChatInputViewController.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 11.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import GrowingTextView
import UIKit

final class ChatInputViewController: UIViewController, IBConstructable {
    private enum Constants {
        static let textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 44)
        static let maxTextViewHeight: CGFloat = 150.0
    }

    @IBOutlet private var inputTextView: GrowingTextView! {
        didSet {
            inputTextView.layer.masksToBounds = true
            inputTextView.textContainerInset = Constants.textContainerInset
            if #available(iOS 13.0, *) {
                inputTextView.accessibilityUserInputLabels = [L10n.Chat.placeholder]
            }
            inputTextView.font = UIFont.systemFont(ofSize: 20)
        }
    }

    @IBOutlet private var sendButton: UIButton!
    var themeController: ThemeController!
    weak var delegate: ChatInputDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardTheme()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        inputTextView.resignFirstResponder()
    }

    private func setKeyboardTheme() {
        themeController.currentTheme.flatMap {
            inputTextView.keyboardAppearance = $0.style.keyboardAppearance
        }
    }

    private func resetInput() {
        inputTextView.text = ""
    }

    private func updateSendButton(_ enabled: Bool) {
        sendButton.isEnabled = enabled
    }

    // MARK: - Actions

    @IBAction func didTapSendButton() {
        guard let text = inputTextView.text, text.canBeSent else {
            return
        }
        delegate?.didTapSendButton(text: text) { [weak self] wasSent in
            guard let self = self else { return }
            if wasSent {
                self.resetInput()
                self.textViewDidChange(self.inputTextView)
            } else {
                Logger.log(.debug, log: .default, "Could not send chat message")
            }
        }
    }
}

extension ChatInputViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else {
            return
        }
        updateSendButton(text.canBeSent)
    }
}

private extension String {
    var canBeSent: Bool {
        !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

class ChatBackGroundView: UIView {}
