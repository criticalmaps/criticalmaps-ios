//
//  Tweet.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import Foundation

struct Tweet: Codable, Hashable {
    var text: String
    var created_at: Date
    var user: TwitterUser
    var id_str: String
}
