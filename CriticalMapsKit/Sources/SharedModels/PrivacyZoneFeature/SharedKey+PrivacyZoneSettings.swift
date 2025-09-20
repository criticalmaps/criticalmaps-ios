import Foundation
import Sharing

public extension SharedKey where Self == FileStorageKey<PrivacyZoneSettings>.Default {
  static var privacyZoneSettings: Self {
    Self[
      .fileStorage(.privacyZones),
      default: PrivacyZoneSettings()
    ]
  }
}

private extension URL {
  static let privacyZones = URL
    .documentsDirectory
    .appending(component: "privacy-zones.json")
}
