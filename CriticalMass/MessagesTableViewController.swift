//
//  MessagesTableViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import UIKit

protocol MessagesTableViewCell: class {
    associatedtype MessageObject

    func setup(for object: MessageObject)
}

extension MessagesTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

class MessagesTableViewController<T: MessagesTableViewCell>: UITableViewController {
    var noContentMessage: String?
    var pullToRefreshTrigger: (((() -> Void)?) -> Void)? {
        didSet {
            let control = UIRefreshControl()
            refreshControl = control
            refreshControl?.addTarget(self, action: #selector(didTriggerRefresh), for: .valueChanged)
        }
    }

    var messages: [T.MessageObject] = [] {
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
        register(cellType: T.self)
    }

    private func updateNoMessageCountIfNeeded() {
        guard let noContentMessage = noContentMessage else {
            return
        }
        if !messages.isEmpty {
            tableView.backgroundView = nil
        } else if tableView.backgroundView == nil {
            let noContentMessageLabel = UILabel()
            noContentMessageLabel.textAlignment = .center
            noContentMessageLabel.numberOfLines = 0
            noContentMessageLabel.text = noContentMessage
            tableView.backgroundView = noContentMessageLabel
        }
    }

    private func register(cellType: T.Type) {
        tableView.register(UINib(nibName: String(describing: cellType), bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)
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

    func update(messages: [T.MessageObject]) {
        self.messages = messages
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
        cell.setup(for: messages[indexPath.row])
        return cell as! UITableViewCell
    }
}
