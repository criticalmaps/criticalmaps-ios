import Dependencies
import Foundation
import SharedModels
import Sharing

// MARK: AppStorageKey

public extension SharedReaderKey where Self == AppStorageKey<Double>.Default {
  /// Chat read timestamp with default value of 0
  static var chatReadTimeInterval: Self {
    Self[.appStorage("chatReadTimeinterval"), default: 0]
  }
}

public extension SharedReaderKey where Self == AppStorageKey<String?> {
  /// Session ID (optional, no default)
  static var sessionID: Self {
    .appStorage("sessionIDKey")
  }
}

public extension SharedReaderKey where Self == AppStorageKey<Bool>.Default {
  /// Whether observation mode prompt was shown, defaults to false
  static var didShowObservationModePrompt: Self {
    Self[.appStorage("didShowObservationModePrompt"), default: false]
  }
}

// MARK: FileStorageKey

public extension SharedKey where Self == FileStorageKey<RideEventSettings>.Default {
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
    Self[.fileStorage(.privacyZones), default: PrivacyZoneSettings()]
  }
}

// MARK: - Helper

private extension URL {
  static let rideEventSettingsURL = Self.jsonFileURL("rideEventSettings")
  static let appearanceSettingsURL = Self.jsonFileURL("appearanceSettings")
  static let privacyZones = Self.jsonFileURL("privacy-zones")
  
  static func jsonFileURL(_ name: String) -> Self {
    applicationSupportDirectory
      .appending(component: name)
      .appendingPathExtension("json")
  }
}

public extension URL {
  static func migratePrivacyZones() {
    let fileManager = FileManager.default
    let oldURL = URL.documentsDirectory
      .appending(component: "privacy-zones.json")

    let doesOldFileExist = fileManager.fileExists(atPath: oldURL.path())
    let doesNewFileExist = fileManager.fileExists(atPath: privacyZones.path())
        
    // Only migrate if old file exists and new one doesn't
    if doesOldFileExist, !doesNewFileExist {
      try? fileManager.moveItem(at: oldURL, to: privacyZones)
    }
  }
}
