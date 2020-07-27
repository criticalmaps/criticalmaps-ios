//
//  Codable+Sugar.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 16.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

extension Encodable {
    func encoded(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        try encoder.encode(self)
    }
}

extension Data {
    func decoded<T: Decodable>(decoder: JSONDecoder = JSONDecoder()) throws -> T {
        try decoder.decode(T.self, from: self)
    }
}

extension JSONDecoder {
    convenience init(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) {
        self.init()
        self.dateDecodingStrategy = dateDecodingStrategy
    }
}
