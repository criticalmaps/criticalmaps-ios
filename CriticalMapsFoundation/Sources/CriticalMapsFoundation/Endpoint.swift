//
//  Endpoint.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 20.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

public struct Endpoint {
    public let path: String?
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

public extension Endpoint {
    static let `default` = Endpoint()
    static let twitter = Endpoint(path: "twitter")
}
