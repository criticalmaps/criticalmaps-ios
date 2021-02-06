//
//  FollowURLObject.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/7/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

struct FollowURLObject: URLCodable {
    let scheme: String? = "criticalmaps"
    let host: String? = "follow"
    let path: String = ""
    let queryObject: Friend
}

extension FollowURLObject {
    init(scheme: String?, host: String?, path: String, queryObject: Friend) throws {
        guard self.scheme == scheme,
              self.host == host,
              self.path == path
        else {
            throw URLCodableError.decodingFailed
        }
        self.queryObject = queryObject
    }
}
