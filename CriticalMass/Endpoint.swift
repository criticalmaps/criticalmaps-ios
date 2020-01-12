//
//  Endpoint.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 20.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

public struct Endpoint {
    public let baseUrl: String
    public let path: String?

    init(baseUrl: String = Constants.apiEndpoint, path: String? = nil) {
        self.baseUrl = baseUrl
        self.path = path
    }
}

extension Endpoint {
    static let `default` = Endpoint()
    static let twitter = Endpoint(path: "twitter")
}
