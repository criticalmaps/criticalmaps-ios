//
//  File.swift
//  
//
//  Created by Malte on 04.06.21.
//

import Foundation

public struct Endpoint {
  public let baseUrl: String
  public let path: String?
  
  public init(baseUrl: String = Endpoints.apiEndpoint, path: String? = nil) {
    self.baseUrl = baseUrl
    self.path = path
  }
}
