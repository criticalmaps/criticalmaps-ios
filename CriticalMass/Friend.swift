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
    let key: Data

    public init(name: String, key: Data) {
        self.name = name
        self.key = key
    }
}
