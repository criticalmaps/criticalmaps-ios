//
//  ChatViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/25/19.
//

import UIKit

class ChatViewController: UIViewController, ChatInputDelegate {
    private let chatInputHeight: CGFloat = 64

    private let chatInput = ChatInputView(frame: .zero)
    private let messagesTableViewController = MessagesTableViewController<ChatMessageTableViewCell>(style: .plain)
    private let chatManager: ChatManager
    private lazy var chatInputBottomConstraint = {
        chatInput.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    }()
    private lazy var chatInputHeightConstraint = {
        chatInput.heightAnchor.constraint(equalToConstant: chatInputHeight)
    }()

    init(chatManager: ChatManager) {
        self.chatManager = chatManager
        super.init(nibName: nil, bundle: nil)
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
            messagesTableViewController.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            messagesTableViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            messagesTableViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messagesTableViewController.view.bottomAnchor.constraint(equalTo: chatInput.topAnchor),
        ])
    }

    private func configureChatInput() {
        chatInput.delegate = self
        view.addSubview(chatInput)

        view.addConstraints([
            chatInputHeightConstraint,
            chatInput.widthAnchor.constraint(equalTo: view.widthAnchor),
            chatInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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

        chatInputHeightConstraint.constant = chatInputHeight + bottomInset
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

    // MARK: ChatInputDelegate

    func didTapSendButton(text: String) {
        let indicator = LoadingIndicator.present(in: view)
        chatManager.send(message: text) { success in
            indicator.dismiss()
            if success {
                self.chatInput.resetInput()
            } else {
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
