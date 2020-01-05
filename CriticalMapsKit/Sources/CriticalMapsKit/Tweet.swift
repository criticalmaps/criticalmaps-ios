//
//  Tweet.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import Foundation

public struct Tweet: Codable, Equatable {
    public var text: String
    public var created_at: Date
    public var user: TwitterUser
    public var id_str: String
}
