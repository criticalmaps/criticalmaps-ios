//
// Created for CriticalMaps in 2020

import UIKit

@available(iOS 13.0.0, *)
final class MessagesDiffableDataSource<T: IBConstructableMessageTableViewCell>: MessagesDataSource<T> {
    private enum Section {
        case main
    }

    private var dataSource: UITableViewDiffableDataSource<Section, T.Model>?

    override var messages: [T.Model] {
        didSet {
            updateDataSource()
        }
    }

    override func configure(tableView: UITableView) {
        super.configure(tableView: tableView)
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, _ in
            let cell = tableView.dequeueReusableCell(ofType: T.self)
            cell.setup(for: self.messages[indexPath.row])

            return cell
        })
    }

    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, T.Model>()
        snapshot.appendSections([.main])
        snapshot.appendItems(messages, toSection: .main)
        dataSource?.apply(snapshot)
    }
}
