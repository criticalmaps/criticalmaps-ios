import Foundation

public typealias HTTPHeaders = [String: String]

public extension HTTPHeaders {
  static let contentTypeApplicationJSON: HTTPHeaders = ["application/json": "Content-Type"]
}
