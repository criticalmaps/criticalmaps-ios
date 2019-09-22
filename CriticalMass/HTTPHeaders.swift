//
//  HTTPHeaders.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 20.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

extension HTTPHeaders {
    static let contentTypeApplicationJSON: HTTPHeaders = ["application/json": "Content-Type"]
}
