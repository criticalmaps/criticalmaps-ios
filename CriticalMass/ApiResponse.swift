//
//  ApiResponse.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

public struct ApiResponse: Codable, Equatable {
    let locations: [String: Location]
    let chatMessages: [String: ChatMessage]
}
