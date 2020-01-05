//
//  Codable+Sugar.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 16.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

public extension Encodable {
    func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
}

public extension Data {
    func decoded<T: Decodable>() throws -> T {
        try JSONDecoder().decode(T.self, from: self)
    }
}
