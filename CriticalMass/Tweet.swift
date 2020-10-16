//
//  Tweet.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import Foundation

struct Tweet: Codable, Hashable {
    var text: String
    var createdAt: Date
    var user: TwitterUser
    var id: String

    private enum CodingKeys: String, CodingKey {
        case text
        case createdAt = "created_at"
        case user
        case id = "id_str"
    }
}
