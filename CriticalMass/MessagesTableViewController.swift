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
    var cellType: T.Type?
    var messages: [T.MessageObject] = []

    public func register(cellType: T.Type) {
        tableView.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        self.cellType = cellType
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = cellType else {
            fatalError("No cell type registred")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as! T
        cell.setup(for: messages[indexPath.row])
        return cell as! UITableViewCell
    }
}
