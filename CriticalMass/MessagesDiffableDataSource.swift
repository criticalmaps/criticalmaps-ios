//
// Created for CriticalMaps in 2020

import UIKit

@available(iOS 13.0.0, *)
final class MessagesDiffableDataSource<T: IBConstructableMessageTableViewCell>: MessagesDataSource<T> {
    private enum Section {
        case main
    }

    private var dataSource: UITableViewDiffableDataSource<Section, T.Model>?

    override func performUpdate(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, T.Model>()
        snapshot.appendSections([.main])
        snapshot.appendItems(messages, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: animated)
    }

    override func configure(tableView: UITableView) {
        super.configure(tableView: tableView)
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, _ in
            self.configuredCell(at: indexPath, in: tableView)
        })
    }
}
