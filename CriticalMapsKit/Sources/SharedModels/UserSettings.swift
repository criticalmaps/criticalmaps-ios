import ComposableArchitecture
import Foundation
import Sharing
import SwiftUI

/// A structure to store a users settings
public struct UserSettings: Codable, Equatable, Sendable {
  public var isObservationModeEnabled: Bool
  public var showInfoViewEnabled: Bool
  public var showActiveRidersOnly: Bool

  public init(
    enableObservationMode: Bool = false,
    showInfoViewEnabled: Bool = true,
    showActiveRidersOnly: Bool = false
  ) {
    isObservationModeEnabled = enableObservationMode
    self.showInfoViewEnabled = showInfoViewEnabled
    self.showActiveRidersOnly = showActiveRidersOnly
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
