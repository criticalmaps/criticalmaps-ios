//
//  ChatManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import Foundation

class ChatManager {
    private let requestManager: RequestManager

    init(requestManager: RequestManager) {
        self.requestManager = requestManager
    }

    public func send(message: String) {
        requestManager.send(messages: [ChatMessage(message: message, timestamp: Date().timeIntervalSince1970)])
    }
}
