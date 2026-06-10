import ComposableArchitecture
import Foundation

/// Configures which server the locations endpoint talks to and how often the app
/// polls. The default is production; a development build (e.g. the
/// `Critical Maps (Local)` scheme) overrides this dependency at the app's
/// composition root to point at a local mock server with a fast poll interval.
public struct ServerConfiguration: Sendable, Equatable {
  /// URL scheme for the locations endpoint, e.g. `"https"` or `"http"`.
  public var scheme: String
  /// Host for the locations endpoint, e.g. `"api-cdn.criticalmaps.net"` or `"localhost"`.
  public var locationsHost: String
  /// Optional port for the locations endpoint (e.g. `8080` for a local server).
  public var locationsPort: Int?
  /// Full poll-cycle length in seconds. The app posts its location at the halfway
  /// point and fetches riders at the full cycle, so production is `60` (30s + 30s).
  public var pollIntervalSeconds: Int

  public init(
    scheme: String = "https",
    locationsHost: String = "api-cdn.criticalmaps.net",
    locationsPort: Int? = nil,
    pollIntervalSeconds: Int = 60
  ) {
    self.scheme = scheme
    self.locationsHost = locationsHost
    self.locationsPort = locationsPort
    self.pollIntervalSeconds = pollIntervalSeconds
  }

  /// The production configuration (Critical Maps CDN over HTTPS, 60s poll cycle).
  public static let production = ServerConfiguration()
}

extension ServerConfiguration: DependencyKey {
  public static let liveValue = ServerConfiguration.production
  public static let testValue = ServerConfiguration.production
}

public extension DependencyValues {
  var serverConfiguration: ServerConfiguration {
    get { self[ServerConfiguration.self] }
    set { self[ServerConfiguration.self] = newValue }
  }
}
