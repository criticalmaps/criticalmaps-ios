import ComposableArchitecture
import Foundation
import Sharing
import SwiftUI

/// A structure to store a users settings
public struct UserSettings: Codable, Equatable, Sendable {
  public var isObservationModeEnabled: Bool
  public var showInfoViewEnabled: Bool
  public var highlightActiveRiders: Bool
  public var gpxRoute: GPXRoute?

  public init(
    enableObservationMode: Bool = false,
    showInfoViewEnabled: Bool = true,
    highlightActiveRiders: Bool = false,
    gpxRoute: GPXRoute? = nil
  ) {
    isObservationModeEnabled = enableObservationMode
    self.showInfoViewEnabled = showInfoViewEnabled
    self.highlightActiveRiders = highlightActiveRiders
    self.gpxRoute = gpxRoute
  }
}

private extension URL {
  static var userSettingsURL: URL {
    URL
      .applicationSupportDirectory
      .appendingPathComponent("userSettings")
      .appendingPathExtension("json")
  }
}

public extension SharedKey where Self == FileStorageKey<UserSettings>.Default {
  static var userSettings: Self {
    Self[.fileStorage(.userSettingsURL), default: UserSettings()]
  }
}
