//
//  File.swift
//  
//
//  Created by Malte on 06.06.21.
//

import Foundation
import SharedModels

public struct PostLocationAndChatMessagesRequest: APIRequest {
  public typealias ResponseDataType = LocationAndChatMessages
  public var endpoint: Endpoint = .init()
  public var headers: HTTPHeaders? = .contentTypeApplicationJSON
  public var httpMethod: HTTPMethod = .post
}
