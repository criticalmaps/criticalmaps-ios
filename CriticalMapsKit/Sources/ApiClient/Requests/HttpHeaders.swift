import Foundation

public typealias HTTPHeaders = [String: String]

public extension HTTPHeaders {
  static let contentTypeApplicationJSON: HTTPHeaders = ["Content-Type": "application/json"]
}
