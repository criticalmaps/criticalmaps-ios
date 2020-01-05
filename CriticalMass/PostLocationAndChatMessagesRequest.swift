//
//  PostLocationRequest.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 16.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import CriticalMapsFoundation
import Foundation

struct PostLocationAndChatMessagesRequest: APIRequestDefining {
    typealias ResponseDataType = ApiResponse
    var endpoint: Endpoint = .default
    var headers: HTTPHeaders? = .contentTypeApplicationJSON
    var httpMethod: HTTPMethod = .post
    var requiresBackgroundTask: Bool = true
}
