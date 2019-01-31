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
        let date = Date(timeIntervalSince1970: message.timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        textLabel?.text = formatter.string(from: date)
        detailTextLabel?.text = message.message
    }
}
