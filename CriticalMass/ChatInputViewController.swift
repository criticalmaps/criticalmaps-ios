//
//  ChatInputViewController.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 11.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

final class ChatInputViewController: UIViewController, IBConstructable {
    private enum Constants {
        static let textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let maxTextViewHeight: CGFloat = 150.0
    }
    @IBOutlet weak var inputTextView: UITextView! {
        didSet {
            inputTextView.layer.masksToBounds = true
            inputTextView.textContainerInset = Constants.textContainerInset
            inputTextView.contentInset = Constants.textContainerInset
        }
    }
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.cornerRadius = sendButton.bounds.height / 2
        }
    }

    weak var delegate: ChatInputDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        inputTextView.resignFirstResponder()
    }

    public func resetInput() {
        inputTextView.text?.removeAll()
    }

    // MARK: - Actions
    @IBAction func didTapSendButton() {
        guard let text = inputTextView.text, text.canBeSent else {
            return
        }
        delegate?.didTapSendButton(text: text)
    }
}

extension ChatInputViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.text.flatMap { sendButton.isEnabled = $0.canBeSent }
        let size = CGSize(width: inputTextView.bounds.width - (Constants.textContainerInset.left * 2),
                          height: .infinity)
        let estimatedHeight = textView.sizeThatFits(size).height
        if estimatedHeight < Constants.maxTextViewHeight {
            inputTextView.isScrollEnabled = false
            inputTextView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedHeight
                }
            }
        } else {
            inputTextView.isScrollEnabled = true
        }
    }
}

private extension String {
    var canBeSent: Bool {
        !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
