//
//  File.swift
//  
//
//  Created by Malte on 06.06.21.
//

import Foundation
import SharedModels

public struct SendLocationAndChatMessagesPostBody: Encodable {
    public let device: String
    public let location: Location?
    public var messages: [SendChatMessage]?
}
