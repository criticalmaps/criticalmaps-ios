//
//  ApiResponse.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

struct ApiResponse: Codable {
    let locations: [String: Location]
    let chatMessages: [String: ChatMessage]
}
