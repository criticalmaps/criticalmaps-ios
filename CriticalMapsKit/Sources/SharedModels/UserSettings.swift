import ComposableArchitecture
import Foundation
import Sharing
import SwiftUI

/// A structure to store a users settings
public struct UserSettings: Codable, Equatable {
  public var isObservationModeEnabled: Bool
  public var showInfoViewEnabled: Bool

  public init(
    enableObservationMode: Bool = false,
    showInfoViewEnabled: Bool = true
  ) {
    isObservationModeEnabled = enableObservationMode
    self.showInfoViewEnabled = showInfoViewEnabled
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

public extension SharedKey
  where Self == Sharing.FileStorageKey<UserSettings>
{
  static var userSettings: Self {
    fileStorage(.userSettingsURL)
  }
}
