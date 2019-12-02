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
    var endpoint: Endpoint = .default
    var headers: HTTPHeaders?
    var httpMethod: HTTPMethod { .get }
}
