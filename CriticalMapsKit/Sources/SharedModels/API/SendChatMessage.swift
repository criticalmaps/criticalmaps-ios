//
//  File.swift
//  
//
//  Created by Malte on 04.06.21.
//

import Foundation

public struct SendChatMessage: Codable, Hashable {
    public var text: String
    public var timestamp: TimeInterval
    public var identifier: String
}
