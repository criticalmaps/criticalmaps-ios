import Foundation
import Helpers

enum APIRequestBuildError: Error {
  case invalidURL
}

public protocol APIRequest {
  associatedtype ResponseDataType: Codable
  var endpoint: Endpoint { get }
  var httpMethod: HTTPMethod { get }
  var headers: HTTPHeaders? { get }
  var queryItems: [URLQueryItem]? { get set }
  var body: Data? { get }
  func makeRequest() throws -> URLRequest
  var decoder: JSONDecoder { get }
}

public extension APIRequest {
  var queryItems: [String: String]? { nil }
  
  func makeRequest() throws -> URLRequest {
    var components = URLComponents()
    components.scheme = "https"
    components.host = endpoint.baseUrl
    if let path = endpoint.path {
      components.path = path
    }
    if let queryItems = queryItems {
      components.queryItems = queryItems
    }
    guard let url = components.url else {
      throw APIRequestBuildError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.rawValue
    request.addHeaders(headers)
    if let body = self.body {
      request.httpBody = body
    }
    return request
  }
  
  var decoder: JSONDecoder {
    JSONDecoder()
  }
}

extension URLRequest {
  mutating func addHeaders(_ httpHeaders: HTTPHeaders?) {
    guard let headers = httpHeaders else {
      return
    }
    for header in headers {
      addValue(header.key, forHTTPHeaderField: header.value)
    }
  }
}
