//
//  ChatMessage.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

public struct ChatMessage: Codable {
    let id = UUID()
    var message: String
    var timestamp: TimeInterval

    var decodedMessage: String? {
        message
            .replacingOccurrences(of: "+", with: " ")
            .removingPercentEncoding
    }

    private enum CodingKeys: String, CodingKey { case message, timestamp }
}

extension ChatMessage: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
