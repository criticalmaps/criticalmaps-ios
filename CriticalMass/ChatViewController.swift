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

    private let messagesTableViewController = MessagesTableViewController<ChatMessageTableViewCell>()
    private let chatManager: ChatManager
    private let chatInputViewController = ChatInputViewController.fromNib()
    private lazy var chatInputBottomConstraint = {
        NSLayoutConstraint(item: chatInputViewController.view!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
    }()

    private lazy var chatInputHeightConstraint = {
        chatInputViewController.view!.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.chatInputHeight)
    }()

    // ContentState
    weak var chatMessageActivityDelegate: ChatMessageActivityDelegate?

    init(chatManager: ChatManager) {
        self.chatManager = chatManager
        super.init(nibName: nil, bundle: nil)
        chatInputViewController.delegate = self
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
        chatInputViewController.resignFirstResponder()
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
        messagesTableViewController.noContentMessage = L10n.chatNoChatActivity
        messagesTableViewController.update(messages: chatManager.getMessages())

        let tapGestureRecoognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTableView))
        messagesTableViewController.view.addGestureRecognizer(tapGestureRecoognizer)
        chatManager.updateMessagesCallback = { [weak self] messages in
            self?.messagesTableViewController.update(messages: messages)
        }

        add(messagesTableViewController)
        messagesTableViewController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints([
            NSLayoutConstraint(item: messagesTableViewController.view!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 0),
            messagesTableViewController.view!.widthAnchor.constraint(equalTo: view.widthAnchor),
            messagesTableViewController.view!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messagesTableViewController.view!.bottomAnchor.constraint(equalTo: chatInputViewController.view!.topAnchor),
        ])
    }

    private func configureChatInput() {
        chatInputViewController.delegate = self
        chatInputViewController.view.translatesAutoresizingMaskIntoConstraints = false
        add(chatInputViewController)

        view.addConstraints([
            chatInputHeightConstraint,
            chatInputViewController.view!.widthAnchor.constraint(equalTo: view.widthAnchor),
            chatInputViewController.view!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chatInputBottomConstraint,
        ])
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        chatInputHeightConstraint.constant = Constants.chatInputHeight + view.safeAreaInsets.bottom
    }

    @objc private func didTapTableView() {
        chatInputViewController.resignFirstResponder()
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
        chatMessageActivityDelegate?.isSendingChatMessage(true)
        chatManager.send(message: text) { [weak self] result in
            self?.chatMessageActivityDelegate?.isSendingChatMessage(false)
            switch result {
            case .success:
                completionHandler?(true)
            case .failure:
                completionHandler?(false)
                AlertPresenter.shared.presentAlert(
                    title: L10n.error,
                    message: L10n.chatSendError,
                    preferredStyle: .alert,
                    actionData: [UIAlertAction(title: L10n.ok, style: .default, handler: nil)]
                )
            }
        }
    }
}
