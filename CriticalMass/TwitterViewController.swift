//
//  TwitterViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import UIKit

class TwitterViewController: UIViewController {
    private let messagesTableViewController = MessagesTableViewController<TweetTableViewCell>(style: .plain)
    private let twitterManager: TwitterManager

    init(twitterManager: TwitterManager) {
        self.twitterManager = twitterManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMessagesTableViewController()
    }

    private func configureMessagesTableViewController() {
        messagesTableViewController.noContentMessage = NSLocalizedString("twitter.noData", comment: "")
        messagesTableViewController.messages = twitterManager.getTweets()
        messagesTableViewController.pullToRefreshTrigger = twitterManager.loadTweets

        twitterManager.updateTweetsCallback = { [weak self] tweets in
            self?.messagesTableViewController.update(messages: tweets)
        }

        addChild(messagesTableViewController)
        view.addSubview(messagesTableViewController.view)
        messagesTableViewController.didMove(toParent: self)
        messagesTableViewController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints([
            NSLayoutConstraint(item: messagesTableViewController.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messagesTableViewController.view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messagesTableViewController.view, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: messagesTableViewController.view, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
        ])
    }
}
