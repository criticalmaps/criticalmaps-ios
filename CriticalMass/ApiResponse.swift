//
//  ApiResponse.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

public struct ApiResponse: Codable, Equatable {
    public let locations: [String: Location]
    public let chatMessages: [String: ChatMessage]
}
