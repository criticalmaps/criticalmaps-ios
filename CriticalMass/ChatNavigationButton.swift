//
//  ChatNavigationButton.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 4/10/19.
//

import UIKit

class ChatNavigationButton: CustomButton {
    let unreadLabel = UILabel()

    init(chatManager: ChatManager) {
        super.init(frame: .zero)
        setImage(UIImage(named: "Chat")!, for: .normal)
        tintColor = .navigationOverlayForeground
        adjustsImageWhenHighlighted = false
        highlightedTintColor = UIColor.navigationOverlayForeground.withAlphaComponent(0.4)
        accessibilityLabel = NSLocalizedString("chat.title", comment: "")
        configureUnreadBubble()
        updateUnreadBubble(unreadCount: chatManager.unreadMessagesCount)
        chatManager.updateUnreadMessagesCountCallback = { [weak self] unreadCount in
            self?.updateUnreadBubble(unreadCount: unreadCount)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUnreadBubble() {
        unreadLabel.frame.size = CGSize(width: 16, height: 16)
        unreadLabel.frame.origin = CGPoint(x: 40, y: 10)
        unreadLabel.backgroundColor = .red
        unreadLabel.textColor = .white
        unreadLabel.font = UIFont.systemFont(ofSize: 11, weight: .heavy)
        unreadLabel.layer.cornerRadius = unreadLabel.frame.size.width / 2
        unreadLabel.layer.masksToBounds = true
        unreadLabel.textAlignment = .center
        unreadLabel.isHidden = true
        addSubview(unreadLabel)
    }

    private func updateUnreadBubble(unreadCount: UInt) {
        unreadLabel.isHidden = unreadCount == 0
        unreadLabel.text = "\(unreadCount)"
    }
}
