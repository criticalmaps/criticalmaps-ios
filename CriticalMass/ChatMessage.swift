//
//  ChatMessage.swift
//  CriticalMapsWatch Extension
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

// {"message":"test ","timestamp":1545064780}

struct ChatMessage: Codable {
    var message: String
    var timeStamp: TimeInterval
}
