//
//  ChatNavigationButtonController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 4/11/19.
//

import Foundation

class ChatNavigationButtonController {
    public var button = ChatNavigationButton()
    private var chatManager: ChatManager

    init(chatManager: ChatManager) {
        self.chatManager = chatManager

        updateButton(unreadCount: chatManager.unreadMessagesCount)
        chatManager.updateUnreadMessagesCountCallback = { [weak self] unreadCount in
            self?.updateButton(unreadCount: unreadCount)
        }
    }

    private func updateButton(unreadCount _: UInt) {
        button.unreadCount = 20
    }
}
