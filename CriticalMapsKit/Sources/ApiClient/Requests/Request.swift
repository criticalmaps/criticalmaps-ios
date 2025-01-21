import Foundation
import Helpers

public struct Request: Sendable {
  let endpoint: Endpoint
  let httpMethod: HTTPMethod
  var headers: [String: String] = defaultHeaders
  var queryItems: [URLQueryItem] = []
  var body: Data?
  var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

  public init(
    endpoint: Endpoint,
    httpMethod: HTTPMethod,
    headers: [String: String] = defaultHeaders,
    queryItems: [URLQueryItem] = [],
    body: Data? = nil,
    cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
  ) {
    self.endpoint = endpoint
    self.httpMethod = httpMethod
    self.headers = headers
    self.queryItems = queryItems
    self.body = body
    self.cachePolicy = cachePolicy
  }

  public func makeRequest() throws -> URLRequest {
    guard var components = URLComponents(string: endpoint.url) else {
      throw APIRequestBuildError.invalidURL
    }
    components.scheme = "https"
    if !queryItems.isEmpty {
      components.queryItems = queryItems
    }
    guard let url = components.url else {
      throw APIRequestBuildError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.rawValue
    request.allHTTPHeaderFields = headers
    request.httpBody = body

    request.cachePolicy = cachePolicy
    return request
  }
}

public extension Request {
  static func get(_ endpoint: Endpoint, query: [URLQueryItem] = []) -> Request {
    Request(endpoint: endpoint, httpMethod: .get, queryItems: query)
  }

  static func post(_ endpoint: Endpoint, body: Data?) -> Request {
    Request(endpoint: endpoint, httpMethod: .post, body: body)
  }

  static func put(_ endpoint: Endpoint, body: Data?) -> Request {
    Request(endpoint: endpoint, httpMethod: .put, body: body)
  }
}

// MARK: Helper

public let defaultHeaders = [
  "Content-Type": "application/json",
  "Client-Version": "iOS-\(Bundle.main.versionNumber).\(Bundle.main.buildNumber)"
]

enum APIRequestBuildError: Error {
  case invalidURL
}
