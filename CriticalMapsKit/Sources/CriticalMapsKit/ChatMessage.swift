//
//  ChatMessage.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

public struct ChatMessage: Codable, Equatable {
    var message: String
    public var timestamp: TimeInterval

    public var decodedMessage: String? {
        message
            .replacingOccurrences(of: "+", with: " ")
            .removingPercentEncoding
    }
}
