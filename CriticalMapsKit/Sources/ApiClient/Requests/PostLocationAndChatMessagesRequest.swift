import Foundation
import SharedModels

public struct PostLocationAndChatMessagesRequest: APIRequest {
  public var queryItems: [URLQueryItem]?
  public typealias ResponseDataType = LocationAndChatMessages
  public let endpoint: Endpoint
  public let headers: HTTPHeaders?
  public let httpMethod: HTTPMethod
  public var body: Data?
  
  public init(
    endpoint: Endpoint = .init(),
    headers: HTTPHeaders? = .contentTypeApplicationJSON,
    httpMethod: HTTPMethod = .post,
    body: Data? = nil
  ) {
    self.endpoint = endpoint
    self.headers = headers
    self.httpMethod = httpMethod
    self.body = body
  }
}

