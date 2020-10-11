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

            accessibilityValue = unreadCount != 0 ? L10n.Chat.Unreadbutton.accessibilityvalue("\(unreadCount)") : nil
        }
    }

    init() {
        super.init(frame: .zero)
        setImage(UIImage(named: "Chat")!, for: .normal)
        adjustsImageWhenHighlighted = false
        accessibilityLabel = L10n.Chat.title

        if #available(iOS 13.0, *) {
            showsLargeContentViewer = true
            scalesLargeContentImage = true
        }
        configureUnreadBubble()
    }

    @available(*, unavailable)
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

    // MARK: Accessibility

    override var largeContentTitle: String? {
        get {
            "\(accessibilityLabel!)" + (unreadCount == 0 ? "" : " (\(unreadLabel.text!))")
        }
        set {}
    }
}
