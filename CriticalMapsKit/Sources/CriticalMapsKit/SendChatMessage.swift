//
//  SendChatMessage.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import Foundation

public struct SendChatMessage: Codable, Equatable {
    var text: String
    var timestamp: TimeInterval
    var identifier: String

    public init(text: String, timestamp: TimeInterval, identifier: String) {
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
