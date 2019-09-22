//
//  Endpoint.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 20.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

struct Endpoint {
    let path: String?
}

extension Endpoint {
    var url: URL {
        guard let path = self.path else {
            return Constants.apiEndpoint
        }
        return Constants.apiEndpoint.appendingPathComponent(path)
    }
}

extension Endpoint {
    init(_ path: String? = nil) {
        self.path = path
    }
}

extension Endpoint {
    static let `default` = Endpoint()
    static let twitter = Endpoint(path: "twitter")
}
