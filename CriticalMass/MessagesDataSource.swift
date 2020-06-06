//
// Created for CriticalMaps in 2020

import UIKit

class MessagesDataSource<T: IBConstructableMessageTableViewCell>: NSObject {
    var messages: [T.Model] = []
    func configure(tableView: UITableView) {
        tableView.tableFooterView = UIView()
        tableView.register(cellType: T.self)
        // To use UITableViews dynamicHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110.0
        tableView.separatorColor = .gray300
    }

    class func dataSource() -> MessagesDataSource {
        if #available(iOS 13.0.0, *) {
            return MessagesDiffableDataSource<T>()
        } else {
            return MessagesDefaultDataSource<T>()
        }
    }
}
