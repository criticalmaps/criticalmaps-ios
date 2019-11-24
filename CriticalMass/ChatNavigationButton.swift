//
//  ChatNavigationButton.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 4/10/19.
//

import UIKit

class ChatNavigationButton: CustomButton {
    @objc
    dynamic var unreadMessagesBackgroundColor: UIColor? {
        willSet {
            unreadLabel.backgroundColor = newValue
        }
    }

    @objc
    dynamic var unreadMessagesTextColor: UIColor? {
        willSet {
            unreadLabel.textColor = newValue
        }
    }

    private let unreadLabel = UILabel()

    public var unreadCount: UInt = 0 {
        didSet {
            unreadLabel.isHidden = unreadCount == 0
            unreadLabel.text = "\(unreadCount)"
            unreadLabel.sizeToFit()
            unreadLabel.frame.size.height = 16
            unreadLabel.frame.size.width = max(16, unreadLabel.frame.size.width + 10)
            unreadLabel.center = CGPoint(x: 55, y: 18)
        }
    }

    init() {
        super.init(frame: .zero)
        setImage(Asset.chat.image, for: .normal)
        adjustsImageWhenHighlighted = false
        accessibilityLabel = L10n.Chat.title
        configureUnreadBubble()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUnreadBubble() {
        unreadLabel.font = UIFont.systemFont(ofSize: 11, weight: .heavy)
        unreadLabel.layer.cornerRadius = 8
        unreadLabel.layer.masksToBounds = true
        unreadLabel.textAlignment = .center
        unreadLabel.isHidden = true
        addSubview(unreadLabel)
    }
}
