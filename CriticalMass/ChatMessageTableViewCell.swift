//
//  ChatMessageTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell, MessagesTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.textColor = .chatMessageDate
        detailTextLabel?.textColor = .chatMessageText
    }

    func setup(for message: ChatMessage) {
        textLabel?.text = "\(message.timestamp)"
        detailTextLabel?.text = message.message
    }

    static func register(for tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self), bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
}
