import Foundation

/// A structure to define an endpoint on the Critical Maps API
public struct Endpoint {
  public let baseUrl: String
  public let path: String?

  public init(baseUrl: String, path: String? = nil) {
    self.baseUrl = baseUrl
    self.path = path
  }
}

public extension Endpoint {
  static let criticalmaps = Self(baseUrl: apiBaseUrl)
  static let twitter = Self(baseUrl: apiBaseUrl, path: "/twitter")

  static let criticalmass = Self(baseUrl: criticalmassInEndpoint, path: "/api/ride")
}

let criticalmassInEndpoint = "criticalmass.in"
let apiBaseUrl = "api.criticalmaps.net"
