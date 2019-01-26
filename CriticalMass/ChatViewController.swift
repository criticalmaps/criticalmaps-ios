//
//  ChatViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/25/19.
//

import UIKit

class ChatViewController: UIViewController {
    let chatInput = ChatInputView(frame: .zero)
    let messagesTableViewController = MessagesTableViewController<ChatMessageTableViewCell>(style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureChatInput()
        configureMessagesTableViewController()
    }

    private func configureMessagesTableViewController() {
        messagesTableViewController.register(cellType: ChatMessageTableViewCell.self)

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
        view.addSubview(chatInput)

        view.addConstraints([
            NSLayoutConstraint(item: chatInput, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64),
            NSLayoutConstraint(item: chatInput, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chatInput, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chatInput, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1, constant: 0),
        ])
    }
}
