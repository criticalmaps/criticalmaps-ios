//
// Created for CriticalMaps in 2020

import UIKit

final class MessagesDefaultDataSource<T: IBConstructableMessageTableViewCell>: MessagesDataSource<T>, UITableViewDataSource {
    override var messages: [T.Model] {
        didSet {
            tableView?.reloadData()
        }
    }

    private weak var tableView: UITableView?

    override func configure(tableView: UITableView) {
        super.configure(tableView: tableView)
        self.tableView = tableView
        tableView.dataSource = self
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in _: UITableView) -> Int {
        1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: T.self)
        cell.setup(for: messages[indexPath.row])

        return cell
    }
}
