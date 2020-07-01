//
// Created for CriticalMaps in 2020

import UIKit

class MessagesDataSource<T: IBConstructableMessageTableViewCell>: NSObject {
    var messages: [T.Model] = [] {
        didSet {
            performUpdate()
        }
    }

    func configure(tableView: UITableView) {
        tableView.tableFooterView = UIView()
        tableView.register(cellType: T.self)
        // To use UITableViews dynamicHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110.0
        tableView.separatorColor = .gray300
    }

    func configuredCell(at indexPath: IndexPath, in tableView: UITableView) -> T {
        let cell = tableView.dequeueReusableCell(ofType: T.self)
        cell.setup(for: messages[indexPath.row])

        return cell
    }

    func performUpdate() {}
}
