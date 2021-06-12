//
//  File.swift
//  
//
//  Created by Malte on 04.06.21.
//

import Foundation

public struct LocationAndChatMessages: Codable, Hashable {
  public let locations: [String: Location]
  public let chatMessages: [String: ChatMessage]
}
