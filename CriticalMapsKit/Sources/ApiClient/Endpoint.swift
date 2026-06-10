import Foundation

/// A structure to define an endpoint on the Critical Maps API
public struct Endpoint: Sendable {
  public let scheme: String
  public let baseUrl: String
  public let port: Int?
  public let pathComponents: [String]

  public init(
    baseUrl: String,
    pathComponents: [String] = [],
    scheme: String = "https",
    port: Int? = nil
  ) {
    self.baseUrl = baseUrl
    self.pathComponents = pathComponents
    self.scheme = scheme
    self.port = port
  }

  var url: String {
    guard !pathComponents.isEmpty else {
      return baseUrl
    }
    let path = pathComponents.joined(separator: "/")
    return "\(baseUrl)/\(path)"
  }
}

public extension Endpoint {
  static let locations = Self(baseUrl: cdnBaseUrl, pathComponents: ["locations"])
  static let chatMessages = Self(baseUrl: apiGWBaseUrl, pathComponents: ["messages"])
  static let criticalmass = Self(baseUrl: criticalmassInEndpoint, pathComponents: ["api", "ride"])
}

let criticalmassInEndpoint = "criticalmass.in"
let cdnBaseUrl = "api-cdn.criticalmaps.net"
let apiGWBaseUrl = "api-gw.criticalmaps.net"
