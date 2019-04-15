//
//  ChatMessage.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

public struct ChatMessage: Codable, Equatable {
    var message: String
    var timestamp: TimeInterval
    
    var decodedMessage: String? {
        return message
            .replacingOccurrences(of: "+", with: " ")
            .removingPercentEncoding
    }
}
