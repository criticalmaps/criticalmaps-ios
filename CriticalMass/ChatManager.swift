//
//  ChatManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import Foundation

class ChatManager {
    private var cachedMessages: [ChatMessage]?
    private let requestManager: RequestManager

    var updateMessagesCallback: (([ChatMessage]) -> Void)?
    var updateUnreadMessagesCountCallback: ((UInt) -> Void)?

    public private(set) var unreadMessagesCount: UInt = 0 {
        didSet {
            if oldValue != unreadMessagesCount {
                updateUnreadMessagesCountCallback?(unreadMessagesCount)
            }
        }
    }

    init(requestManager: RequestManager) {
        self.requestManager = requestManager
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMessages(notification:)), name: NSNotification.Name("chatMessagesReceived"), object: nil)
    }

    @objc private func didReceiveMessages(notification: Notification) {
        guard let response = notification.object as? ApiResponse else { return }
        cachedMessages = Array(response.chatMessages.values).sorted(by: { (a, b) -> Bool in
            a.timestamp > b.timestamp
        })
        unreadMessagesCount = UInt(cachedMessages?.lazy.filter { $0.timestamp > Preferences.lastMessageReadTimeInterval }.count ?? 0)
        updateMessagesCallback?(cachedMessages ?? [])
    }

    public func send(message: String, completion: @escaping (Bool) -> Void) {
        requestManager.send(messages: [SendChatMessage(text: message, timestamp: Date().timeIntervalSince1970, identifier: UUID().uuidString.md5)]) { response in
            completion(response != nil)
        }
    }

    public func getMessages() -> [ChatMessage] {
        if cachedMessages == nil {
            // force api request if message are requested but not available
            requestManager.getData()
            cachedMessages = []
        }
        return cachedMessages!
    }

    public func markAllMessagesAsRead() {
        if let timestamp = cachedMessages?.first?.timestamp {
            Preferences.lastMessageReadTimeInterval = timestamp
        }
        unreadMessagesCount = 0
    }
}
