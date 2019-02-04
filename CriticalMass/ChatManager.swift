//
//  ChatManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import Foundation

class ChatManager {
    private var cachedMessage: [ChatMessage]?
    private let requestManager: RequestManager

    var updateMessagesCallback: (([ChatMessage]) -> Void)?

    init(requestManager: RequestManager) {
        self.requestManager = requestManager
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMessages(notification:)), name: NSNotification.Name("chatMessagesReceived"), object: nil)
    }

    @objc private func didReceiveMessages(notification: Notification) {
        guard let response = notification.object as? ApiResponse else { return }
        cachedMessage = Array(response.chatMessages.values).sorted(by: { (a, b) -> Bool in
            a.timestamp > b.timestamp
        })
        updateMessagesCallback?(cachedMessage ?? [])
    }

    public func send(message: String, completion: @escaping (Bool) -> Void) {
        requestManager.send(messages: [SendChatMessage(text: message, timestamp: Date().timeIntervalSince1970, identifier: UUID().uuidString.md5)]) { response in
            completion(response != nil)
        }
    }

    public func getMessages() -> [ChatMessage] {
        if cachedMessage == nil {
            // force api request if message are requested but not available
            requestManager.getData()
            cachedMessage = []
        }
        return cachedMessage!
    }
}
