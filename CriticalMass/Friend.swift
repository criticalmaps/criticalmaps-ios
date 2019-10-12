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
    let token: Data

    public init(name: String, token: Data) {
        self.name = name
        self.token = token
    }
}
