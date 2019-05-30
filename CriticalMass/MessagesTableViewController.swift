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
    var pullToRefreshTrigger: (((() -> Void)?) -> Void)? {
        didSet {
            let control = UIRefreshControl()
            refreshControl = control
            refreshControl?.addTarget(self, action: #selector(didTriggerRefresh), for: .valueChanged)
        }
    }

    var messages: [T.Model] = [] {
        didSet {
            // TODO: implement diffing to only reload cells that changed
            tableView.reloadData()
            updateNoMessageCountIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting the footerView hides seperators for empty cellls
        tableView.tableFooterView = UIView()
        tableView.register(cellType: T.self)
        // To use UITableViews dynamicHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110.0
    }

    private func updateNoMessageCountIfNeeded() {
        guard let noContentMessage = noContentMessage else {
            return
        }
        if !messages.isEmpty {
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
        pullToRefreshTrigger? { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return messages.count
    }

    func update(messages: [T.Model]) {
        self.messages = messages
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: T.self)
        cell.setup(for: messages[indexPath.row])
        return cell
    }
}
