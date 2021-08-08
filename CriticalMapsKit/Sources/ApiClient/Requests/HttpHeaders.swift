//
//  File.swift
//  
//
//  Created by Malte on 04.06.21.
//

import Foundation

public typealias HTTPHeaders = [String: String]

extension HTTPHeaders {
  public static let contentTypeApplicationJSON: HTTPHeaders = ["application/json": "Content-Type"]
}
