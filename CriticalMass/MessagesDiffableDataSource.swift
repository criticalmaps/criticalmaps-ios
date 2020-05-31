//
// Created for CriticalMaps in 2020

import UIKit

@available(iOS 13.0.0, *)
final class MessagesDiffableDataSource<T: IBConstructableMessageTableViewCell> {
    var messages: [T.Model] = [] {
        didSet {
            updateTableView()
        }
    }

    private var dataSource: UITableViewDiffableDataSource<Int, T.Model>?

    func configure(with tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, _ in
            let cell = tableView.dequeueReusableCell(ofType: T.self)
            cell.setup(for: self.messages[indexPath.row])

            return cell
        })
    }

    private func updateTableView() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, T.Model>()
        snapshot.appendItems(messages)

        dataSource?.apply(snapshot)
    }
}
