//
//  ChatViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/25/19.
//

import UIKit

class ChatViewController: UIViewController, ChatInputDelegate {
    private let chatInput = ChatInputView(frame: .zero)
    private let messagesTableViewController = MessagesTableViewController<ChatMessageTableViewCell>(style: .plain)
    private let chatManager: ChatManager
    private lazy var chatInputBottomConstraint = {
        NSLayoutConstraint(item: chatInput, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1, constant: 0)
    }()

    @objc init(chatManager: ChatManager) {
        self.chatManager = chatManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNotifications()
        configureNavigationBar()
        configureChatInput()
        configureMessagesTableViewController()
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configureNavigationBar() {
        title = NSLocalizedString("chat.title", comment: "")
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    private func configureMessagesTableViewController() {
        messagesTableViewController.noContentMessage = NSLocalizedString("chat.noChatActivity", comment: "")
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
            NSLayoutConstraint(item: messagesTableViewController.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messagesTableViewController.view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messagesTableViewController.view, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messagesTableViewController.view, attribute: .bottom, relatedBy: .equal, toItem: chatInput, attribute: .top, multiplier: 1, constant: 0),
        ])
    }

    private func configureChatInput() {
        chatInput.delegate = self
        view.addSubview(chatInput)

        view.addConstraints([
            NSLayoutConstraint(item: chatInput, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64),
            NSLayoutConstraint(item: chatInput, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chatInput, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            chatInputBottomConstraint,
        ])
    }

    @objc private func didTapTableView() {
        chatInput.resignFirstResponder()
    }

    // MARK: Keyboard Handling

    @objc private func keyboardWillShow(notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        chatInputBottomConstraint.constant = (endFrame.minY - beginFrame.minY) + (view.frame.maxY - chatInput.frame.maxY)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc private func keyboardWillHide(notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt

        chatInputBottomConstraint.constant = 0
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
                UIAlertView(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("chat.send.error", comment: ""), delegate: nil, cancelButtonTitle: "Ok").show()
            }
        }
    }
}
