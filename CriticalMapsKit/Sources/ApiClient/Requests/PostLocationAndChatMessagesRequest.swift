//
//  File.swift
//  
//
//  Created by Malte on 06.06.21.
//

import Foundation
import SharedModels

public struct PostLocationAndChatMessagesRequest: APIRequest {
  public func parseResponse(data: Data) throws -> LocationAndChatMessages {
    .init(locations: [:], chatMessages: [:])
  }
  
  public init(
    endpoint: Endpoint = .init(),
    headers: HTTPHeaders? = ["application/json": "Content-Type"],
    httpMethod: HTTPMethod = .post,
    body: Data? = nil
  ) {
    self.endpoint = endpoint
    self.headers = headers
    self.httpMethod = httpMethod
    self.body = body
  }
  
  public typealias ResponseDataType = LocationAndChatMessages
  public let endpoint: Endpoint
  public let headers: HTTPHeaders?
  public let httpMethod: HTTPMethod
  public var body: Data?
}
