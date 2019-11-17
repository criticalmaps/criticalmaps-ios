//
//  ChatViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/25/19.
//

import UIKit

protocol ChatInputDelegate: AnyObject {
    func didTapSendButton(text: String, completionHandler: ChatViewController.CompletionHandler?)
}

class ChatViewController: UIViewController {
    typealias CompletionHandler = (Bool) -> Void
    private enum Constants {
        static let chatInputHeight: CGFloat = 180
    }

    private let messagesTableViewController = MessagesTableViewController<ChatMessageTableViewCell>(style: .plain)
    private let chatManager: ChatManager
    private let chatInput: ChatInputViewController
    private lazy var chatInputBottomConstraint = {
        NSLayoutConstraint(item: chatInput.view!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
    }()

    private lazy var chatInputHeightConstraint = {
        NSLayoutConstraint(item: chatInput.view!, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.chatInputHeight)
    }()

    init(chatManager: ChatManager, chatInputViewController: ChatInputViewController) {
        self.chatManager = chatManager
        self.chatInput = chatInputViewController
        super.init(nibName: nil, bundle: nil)
        self.chatInput.delegate = self
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNotifications()
        configureChatInput()
        configureMessagesTableViewController()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatInput.resignFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        chatManager.markAllMessagesAsRead()
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configureMessagesTableViewController() {
        messagesTableViewController.noContentMessage = String.chatNoChatActivity
        messagesTableViewController.messages = chatManager.getMessages()

        let tapGestureRecoognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTableView))
        messagesTableViewController.view.addGestureRecognizer(tapGestureRecoognizer)
        chatManager.updateMessagesCallback = { [weak self] messages in
            self?.messagesTableViewController.update(messages: messages)
        }

        addChild(messagesTableViewController)
        view.addSubview(messagesTableViewController.view)
        messagesTableViewController.didMove(toParent: self)
        messagesTableViewController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints([
            NSLayoutConstraint(item: messagesTableViewController.view!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messagesTableViewController.view!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messagesTableViewController.view!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messagesTableViewController.view!, attribute: .bottom, relatedBy: .equal, toItem: chatInput.view!, attribute: .top, multiplier: 1, constant: 0),
        ])
    }

    private func configureChatInput() {
        chatInput.delegate = self
        chatInput.view.translatesAutoresizingMaskIntoConstraints = false
        add(chatInput)

        view.addConstraints([
            chatInputHeightConstraint,
            NSLayoutConstraint(item: chatInput.view!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chatInput.view!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            chatInputBottomConstraint,
        ])
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        let bottomInset: CGFloat
        if #available(iOS 11.0, *), chatInputBottomConstraint.constant == 0 {
            bottomInset = view.safeAreaInsets.bottom
        } else {
            bottomInset = 0
        }

        chatInputHeightConstraint.constant = Constants.chatInputHeight + bottomInset
    }

    @objc private func didTapTableView() {
        chatInput.resignFirstResponder()
    }

    // MARK: Keyboard Handling

    @objc private func keyboardWillShow(notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        chatInputBottomConstraint.constant = -endFrame.height
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc private func keyboardWillHide(notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt

        chatInputBottomConstraint.constant = 0
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: ChatInputDelegate
extension ChatViewController: ChatInputDelegate {
    func didTapSendButton(text: String, completionHandler: CompletionHandler? = nil) {
        chatManager.send(message: text) { result in
            switch result {
            case .success:
                completionHandler?(true)
            case .failure:
                completionHandler?(false)
                let alert = UIAlertController(title: String.error,
                                              message: String.chatSendError,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok",
                                              style: .default,
                                              handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
