//
//  ChatMessageTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell, MessagesTableViewCell {
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var chatTextView: UITextView! {
        didSet {
            // removes the padding from the textview
            let padding = chatTextView.textContainer.lineFragmentPadding
            chatTextView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        timeLabel?.textColor = .chatMessageDate
        chatTextView?.textColor = .chatMessageText
    }

    func setup(for message: ChatMessage) {
        let date = Date(timeIntervalSince1970: message.timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel?.text = formatter.string(from: date)
        chatTextView?.text = message.message
    }
}
