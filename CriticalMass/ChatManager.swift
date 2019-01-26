//
//  ChatManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import Foundation

@objc(PLChatManager)
class ChatManager: NSObject {
    private let requestManager: RequestManager

    @objc init(requestManager: RequestManager) {
        self.requestManager = requestManager
        super.init()
    }

    public func send(message: String, completion: @escaping (Bool) -> Void) {
        requestManager.send(messages: [SendChatMessage(text: message, timestamp: Date().timeIntervalSince1970, identifier: UUID().uuidString.md5)]) { response in
            completion(response != nil)
        }
    }
}
