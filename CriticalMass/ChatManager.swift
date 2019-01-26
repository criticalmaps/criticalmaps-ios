//
//  ChatManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import Foundation

@objc(PLChatManager)
class ChatManager: NSObject {
    private var cachedMessage: [ChatMessage] = []
    private let requestManager: RequestManager

    var updateMessagesCallback: (([ChatMessage]) -> Void)?

    @objc init(requestManager: RequestManager) {
        self.requestManager = requestManager
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMessages(notification:)), name: NSNotification.Name("chatMessagesReceived"), object: nil)
    }

    @objc private func didReceiveMessages(notification: Notification) {
        guard let response = notification.object as? ApiResponse else { return }
        // TODO sort messages
        cachedMessage = Array(response.chatMessages.values)
        updateMessagesCallback?(cachedMessage)
    }

    public func send(message: String, completion: @escaping (Bool) -> Void) {
        requestManager.send(messages: [SendChatMessage(text: message, timestamp: Date().timeIntervalSince1970, identifier: UUID().uuidString.md5)]) { response in
            completion(response != nil)
        }
    }

    public func getMessages() -> [ChatMessage] {
        return cachedMessage
    }
}
