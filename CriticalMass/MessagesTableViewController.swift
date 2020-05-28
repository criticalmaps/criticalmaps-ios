//
//  MessagesTableViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import UIKit

protocol MessageConfigurable: AnyObject {
    associatedtype Model
    func setup(for object: Model)
}

typealias IBConstructableMessageTableViewCell = UITableViewCell & IBConstructable & MessageConfigurable

class MessagesTableViewController<T: IBConstructableMessageTableViewCell>: UITableViewController {
    var noContentMessage: String?
    var pullToRefreshTrigger: ((ResultCallback<[Tweet]>?) -> Void)? {
        didSet {
            let control = UIRefreshControl()
            refreshControl = control
            refreshControl?.addTarget(self, action: #selector(didTriggerRefresh), for: .valueChanged)
        }
    }

    private let dataSource = MessagesTableViewDataSource<T>()

    var selectMessageTrigger: ((T.Model) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        // Setting the footerView hides seperators for empty cellls
        tableView.tableFooterView = UIView()
        tableView.register(cellType: T.self)
        tableView.dataSource = dataSource
        // To use UITableViews dynamicHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110.0
        tableView.separatorColor = .gray300
    }

    private func updateNoMessageCountIfNeeded() {
        guard let noContentMessage = noContentMessage else {
            return
        }
        if !dataSource.messages.isEmpty {
            tableView.backgroundView = nil
        } else if tableView.backgroundView == nil {
            let noContentMessageLabel = NoContentMessageLabel()
            noContentMessageLabel.text = noContentMessage
            noContentMessageLabel.font = UIFont.preferredFont(forTextStyle: .body)
            tableView.backgroundView = noContentMessageLabel
        }
    }

    @objc private func didTriggerRefresh() {
        refreshControl?.beginRefreshing()
        pullToRefreshTrigger? { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }

    func update(messages: [T.Model]) {
        dataSource.messages = messages
        updateNoMessageCountIfNeeded()
        tableView.reloadData()
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectMessageTrigger?(dataSource.messages[indexPath.row])
    }
}
