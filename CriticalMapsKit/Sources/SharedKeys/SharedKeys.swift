import Foundation
import SharedModels
import Sharing

public extension SharedReaderKey where Self == AppStorageKey<Double>.Default {
  /// Chat read timestamp with default value of 0
  static var chatReadTimeInterval: Self {
    Self[.appStorage("chatReadTimeInterval"), default: 0]
  }
}

public extension SharedReaderKey where Self == AppStorageKey<String?> {
  /// Session ID (optional, no default)
  static var sessionID: Self {
    .appStorage("sessionID")
  }
}

public extension SharedReaderKey where Self == AppStorageKey<Bool>.Default {
  /// Whether observation mode prompt was shown, defaults to false
  static var didShowObservationModePrompt: Self {
    Self[.appStorage("didShowObservationModePrompt"), default: false]
  }
}

public extension SharedKey where Self == Sharing.FileStorageKey<RideEventSettings>.Default {
  static var rideEventSettings: Self {
    Self[.fileStorage(.rideEventSettingsURL), default: RideEventSettings()]
  }
}

public extension SharedKey where Self == FileStorageKey<AppearanceSettings>.Default {
  static var appearanceSettings: Self {
    Self[.fileStorage(.appearanceSettingsURL), default: AppearanceSettings()]
  }
}

public extension SharedKey where Self == FileStorageKey<PrivacyZoneSettings>.Default {
  static var privacyZoneSettings: Self {
    Self[
      .fileStorage(.privacyZones),
      default: PrivacyZoneSettings()
    ]
  }
}

// MARK: - Helper

private extension URL {
  static var rideEventSettingsURL: URL {
    URL
      .applicationSupportDirectory
      .appendingPathComponent("rideEventSettings")
      .appendingPathExtension("json")
  }
  
  static var appearanceSettingsURL: URL {
    URL
      .applicationSupportDirectory
      .appendingPathComponent("appearanceSettings")
      .appendingPathExtension("json")
  }
  
  static let privacyZones = URL
    .documentsDirectory
    .appending(component: "privacy-zones.json")
}
