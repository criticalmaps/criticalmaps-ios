//
//  ChatMessageTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell, MessagesTableViewCell {
    @objc
    dynamic var timeLabelTextColor: UIColor? {
        willSet {
            timeLabel.textColor = newValue
        }
    }

    @objc
    dynamic var chatTextColor: UIColor? {
        willSet {
            chatTextView.textColor = newValue
        }
    }

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
        timeLabel?.text = FormatDisplay.hoursAndMinutesDateString(from: message)
        chatTextView?.text = message.decodedMessage
    }
}
