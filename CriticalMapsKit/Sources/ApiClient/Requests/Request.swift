import Foundation

public struct Request {
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
    var components = URLComponents()
    components.scheme = "https"
    components.host = endpoint.baseUrl
    if let path = endpoint.path {
      components.path = path
    }
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

// MARK: Helper

public let defaultHeaders = ["Content-Type": "application/json"]

enum APIRequestBuildError: Error {
  case invalidURL
}
