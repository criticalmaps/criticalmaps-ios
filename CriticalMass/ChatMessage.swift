//
//  ChatMessage.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

struct ChatMessage: Codable, Equatable {
    var text: String
    var timestamp: TimeInterval
    var identifier: String
}
