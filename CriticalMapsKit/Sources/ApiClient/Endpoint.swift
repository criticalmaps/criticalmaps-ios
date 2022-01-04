import Foundation

/// A structure to define an endpoint on the Critical Maps API
public struct Endpoint {
  public let baseUrl: String
  public let path: String?
  
  public init(baseUrl: String = Endpoints.apiEndpoint, path: String? = nil) {
    self.baseUrl = baseUrl
    self.path = path
  }
}

public extension Endpoint {
  static let twitter = Endpoint(path: "/twitter")
}
