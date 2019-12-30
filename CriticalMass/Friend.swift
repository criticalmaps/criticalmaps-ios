//
//  Friend.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/7/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

public struct Friend: Codable, Equatable, Hashable {
    let name: String
    let token: String
    var location: Location?
    var isOnline: Bool {
        location != nil
    }

    public init(name: String, token: String, location: Location? = nil) {
        self.name = name
        self.token = token
        self.location = location
    }
}
