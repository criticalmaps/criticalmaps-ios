//
//  File.swift
//  
//
//  Created by Malte on 04.06.21.
//

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
  var queryItems: [String: String]? { get }
  func makeRequest() throws -> URLRequest
  func parseResponse(data: Data) throws -> ResponseDataType
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
      components.setQueryItems(with: queryItems)
    }
    guard let url = components.url else {
      throw APIRequestBuildError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.rawValue
    request.addHeaders(headers)
    return request
  }
  
  func parseResponse(data: Data) throws -> ResponseDataType {
    try data.decoded()
  }
}

extension URLComponents {
  mutating func setQueryItems(with parameters: [String: String]) {
    queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
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
