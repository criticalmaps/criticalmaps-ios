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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTweets()
    }

    private func fetchTweets() {
        let loadingViewController = LoadingViewController()
        add(loadingViewController)
        twitterManager.loadTweets { [weak self] result in
            self?.messagesTableViewController.refreshControl?.endRefreshing()
            loadingViewController.remove()
            switch result {
            case let .failure(error):
                Logger.log(.error, log: .network, "Failed loading the data")
                debugPrint(error.localizedDescription) // TODO: Handle error
            case let .success(tweets):
                self?.messagesTableViewController.update(messages: tweets)
            }
        }
    }

    private func configureMessagesTableViewController() {
        messagesTableViewController.noContentMessage = String.twitterNoData
        messagesTableViewController.pullToRefreshTrigger = fetchTweets
        addChild(messagesTableViewController)
        view.addSubview(messagesTableViewController.view)
        messagesTableViewController.didMove(toParent: self)
        messagesTableViewController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints([
            messagesTableViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            messagesTableViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            messagesTableViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messagesTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        // inset tableView seperator
        messagesTableViewController.tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 73.0, bottom: 0.0, right: 0.0)
    }
}
