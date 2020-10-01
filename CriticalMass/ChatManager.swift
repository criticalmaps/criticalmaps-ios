//
//  ChatManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import Crypto
import Foundation

protocol ChatMessageStore {
    var lastMessageReadTimeInterval: Double { get set }
}

class ChatManager {
    private var cachedMessages: [ChatMessage]?
    private let requestManager: RequestManager
    private let errorHandler: ErrorHandler
    private var chatMessageStorage: ChatMessageStore

    var updateMessagesCallback: (([ChatMessage]) -> Void)?
    var updateUnreadMessagesCountCallback: ((UInt) -> Void)?

    public private(set) var unreadMessagesCount: UInt = 0 {
        didSet {
            if oldValue != unreadMessagesCount {
                updateUnreadMessagesCountCallback?(unreadMessagesCount)
            }
        }
    }

    init(
        requestManager: RequestManager,
        chatMessageStorage: ChatMessageStore,
        errorHandler: ErrorHandler = PrintErrorHandler()
    ) {
        self.chatMessageStorage = chatMessageStorage
        self.requestManager = requestManager
        self.errorHandler = errorHandler
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveMessages(notification:)),
            name: .chatMessagesReceived, object: nil
        )
    }

    @objc private func didReceiveMessages(notification: Notification) {
        guard let response = notification.object as? ApiResponse else { return }
        cachedMessages = Array(response.chatMessages.values).sorted(by: \.timestamp, sortOperator: >)
        unreadMessagesCount = UInt(cachedMessages!.lazy.filter { $0.timestamp > self.chatMessageStorage.lastMessageReadTimeInterval }.count)
        updateMessagesCallback?(cachedMessages!)
    }

    public func send(message: String, completion: @escaping ResultCallback<[String: ChatMessage]>) {
        // TODO: use sha256 after the server supports it
        let messages = [SendChatMessage(text: message,
                                        timestamp: Date().timeIntervalSince1970,
                                        identifier: UUID().uuidString.md5!)]
        requestManager.send(messages: messages) { result in
            switch result {
            case let .success(messages):
                completion(.success(messages))
            case let .failure(error):
                self.errorHandler.handleError(error)
                completion(.failure(error))
            }
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
            chatMessageStorage.lastMessageReadTimeInterval = timestamp
        }
        unreadMessagesCount = 0
    }
}
