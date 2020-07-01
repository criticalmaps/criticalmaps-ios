//
//  MessagesTableViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import UIKit

class MessagesTableViewController<T: IBConstructableMessageTableViewCell>: UITableViewController {
    var noContentMessage: String?
    var pullToRefreshTrigger: ((ResultCallback<[Tweet]>?) -> Void)? {
        didSet {
            let control = UIRefreshControl()
            refreshControl = control
            refreshControl?.addTarget(self, action: #selector(didTriggerRefresh), for: .valueChanged)
        }
    }

    convenience init() {
        if #available(iOS 13.0.0, *) {
            self.init(dataSource: MessagesDiffableDataSource())
        } else {
            self.init(dataSource: MessagesDefaultDataSource())
        }
    }

    init(dataSource: MessagesDataSource<T>) {
        self.dataSource = dataSource
        super.init(style: .plain)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let dataSource: MessagesDataSource<T>

    var selectMessageTrigger: ((T.Model) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.configure(tableView: tableView)
        if !dataSource.messages.isEmpty {
            dataSource.performUpdate(animated: false)
        }
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
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectMessageTrigger?(dataSource.messages[indexPath.row])
    }
}
