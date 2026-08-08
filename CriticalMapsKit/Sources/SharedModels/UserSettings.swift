import ComposableArchitecture
import Foundation
import Sharing
import SwiftUI

/// A structure to store a users settings
public struct UserSettings: Codable, Equatable, Sendable {
  public var isObservationModeEnabled: Bool
  public var showInfoViewEnabled: Bool
  public var highlightActiveRiders: Bool
  public var highlightColor: RiderHighlightColor?
  public var gpxRoute: GPXRoute?

  public init(
    enableObservationMode: Bool = false,
    showInfoViewEnabled: Bool = true,
    highlightActiveRiders: Bool = false,
    highlightColor: RiderHighlightColor? = nil,
    gpxRoute: GPXRoute? = nil
  ) {
    isObservationModeEnabled = enableObservationMode
    self.showInfoViewEnabled = showInfoViewEnabled
    self.highlightActiveRiders = highlightActiveRiders
    self.highlightColor = highlightColor
    self.gpxRoute = gpxRoute
  }
}

/// A user-selectable color for highlighting active riders on the map, stored
/// in the extended sRGB color space so it round-trips through `Color`.
public struct RiderHighlightColor: Codable, Equatable, Sendable {
  public var red: Double
  public var green: Double
  public var blue: Double

  public init(red: Double, green: Double, blue: Double) {
    self.red = red
    self.green = green
    self.blue = blue
  }

  public init(color: Color) {
    let resolved = color.resolve(in: EnvironmentValues())
    red = Double(resolved.red)
    green = Double(resolved.green)
    blue = Double(resolved.blue)
  }

  public var color: Color {
    Color(.sRGB, red: red, green: green, blue: blue)
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
