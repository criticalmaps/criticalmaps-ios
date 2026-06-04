import ApiClient
import Foundation

/// Resolves the `ServerConfiguration` for the current build.
///
/// This lives in the **app target** (not the CriticalMapsKit package) because the
/// `DEBUG_LOCAL` compile flag is set per build configuration on the app target,
/// where compile flags reliably apply — they do not reliably propagate into
/// integrated Swift Package targets. The resolved value is injected into the
/// package at the app's composition root (see `CriticalMapsApp`).
enum AppConfiguration {
  /// Human-readable name of the active environment, for logging.
  static var environmentName: String {
    #if DEBUG_LOCAL
      return "LOCAL (mock server)"
    #else
      return "PRODUCTION"
    #endif
  }

  static var serverConfiguration: ServerConfiguration {
    #if DEBUG_LOCAL
      // Points at the local mock server, which lives in its own repository
      // (criticalmaps-mock-server). Start it with `swift run`, then launch the
      // "Critical Maps (Local)" scheme. Fast poll cycle so the simulated ride is
      // visible to move within seconds.
      // Real device: replace "localhost" with your Mac's LAN IP.
      return ServerConfiguration(
        scheme: "http",
        locationsHost: "localhost",
        locationsPort: 8080,
        pollIntervalSeconds: 10
      )
    #else
      return .production
    #endif
  }
}
