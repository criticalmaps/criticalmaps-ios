//
//  PostChatMessagesRequest.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 16.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

struct PostChatMessagesRequest: APIRequestDefining {
    typealias ResponseDataType = ApiResponse
    var baseUrl: URL
    var paths: [String]
    var headers: HTTPHeaders?
    var httpMethod: HTTPMethod { return .post }
}
