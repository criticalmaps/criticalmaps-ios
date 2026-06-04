import ApiClient
import AppFeature
import AppIntentFeature
import ComposableArchitecture
import OSLog
import SwiftUI

@main
struct CriticalMapsApp: App {
  @MainActor
  static let store = Store(initialState: AppFeature.State()) {
    AppFeature()
  }

  var body: some Scene {
    WindowGroup {
      AppView(store: Self.store)
    }
  }

  init() {
    // Inject the server configuration (production by default; local mock server on
    // the `Critical Maps (Local)` build) before the store is first accessed.
    let configuration = AppConfiguration.serverConfiguration
    prepareDependencies {
      $0.serverConfiguration = configuration
    }

    // Log which backend the app booted against, so it's easy to confirm the
    // active environment in the Xcode console.
    let host = [configuration.locationsHost, configuration.locationsPort.map(String.init)]
      .compactMap(\.self)
      .joined(separator: ":")
    Logger.boot.notice(
      """
      🚲 Critical Maps booting · environment=\(AppConfiguration.environmentName, privacy: .public) \
      · locations=\(configuration.scheme, privacy: .public)://\(host, privacy: .public)/locations \
      · pollInterval=\(configuration.pollIntervalSeconds, privacy: .public)s
      """
    )

    CriticalMapsShortcuts.updateAppShortcutParameters()
  }
}

private extension Logger {
  static let boot = Logger(subsystem: "CriticalMaps", category: "Boot")
}
