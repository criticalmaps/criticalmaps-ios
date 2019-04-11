//
//  ChatNavigationButton.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 4/10/19.
//

import UIKit

class ChatNavigationButton: CustomButton {
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
        setImage(UIImage(named: "Chat")!, for: .normal)
        tintColor = .navigationOverlayForeground
        adjustsImageWhenHighlighted = false
        highlightedTintColor = UIColor.navigationOverlayForeground.withAlphaComponent(0.4)
        accessibilityLabel = NSLocalizedString("chat.title", comment: "")
        configureUnreadBubble()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUnreadBubble() {
        unreadLabel.backgroundColor = .red
        unreadLabel.textColor = .white
        unreadLabel.font = UIFont.systemFont(ofSize: 11, weight: .heavy)
        unreadLabel.layer.cornerRadius = 8
        unreadLabel.layer.masksToBounds = true
        unreadLabel.textAlignment = .center
        unreadLabel.isHidden = true
        addSubview(unreadLabel)
    }
}
