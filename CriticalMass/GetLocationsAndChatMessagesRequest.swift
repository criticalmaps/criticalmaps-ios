//
//  GetLocationsAndChatMessagesRequest.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 11.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

struct GetLocationsAndChatMessagesRequest: APIRequestDefining {
    typealias ResponseDataType = ApiResponse
    var baseUrl: URL
    var paths: [String]
    var httpMethod: HTTPMethod { return .get }
    var headers: HTTPHeaders?

    func parseResponse(data: Data) throws -> ResponseDataType {
        return try data.decoded()
    }
}
