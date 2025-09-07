import Foundation
import Sharing
import SharedModels

extension SharedKey where Self == FileStorageKey<PrivacyZoneSettings>.Default {
  public static var privacyZoneSettings: Self {
    Self[
      .fileStorage(.documentsDirectory.appending(component: "privacy-zones.json")),
      default: PrivacyZoneSettings()
    ]
  }
}
