//
//  ChatMessageTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import CriticalMapsKit
import UIKit

class ChatMessageTableViewCell: UITableViewCell, MessageConfigurable, IBConstructable {
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

    @IBOutlet private var timeLabel: UILabel! {
        didSet {
            timeLabel.font = UIFont.scalableSystemFont(fontSize: 15, weight: .bold)
        }
    }

    @IBOutlet private var chatTextView: UITextView! {
        didSet {
            // removes the padding from the textview
            let padding = chatTextView.textContainer.lineFragmentPadding
            chatTextView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        }
    }

    func setup(for message: ChatMessage) {
        timeLabel?.text = FormatDisplay.hoursAndMinutesDateString(from: message)
        chatTextView?.text = message.decodedMessage
    }
}
