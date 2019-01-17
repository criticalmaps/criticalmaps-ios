//
//  ChatMessage.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

struct ChatMessage: Codable, Equatable {
    var message: String
    var timeStamp: TimeInterval
}
