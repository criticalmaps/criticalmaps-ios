import Foundation
import SwiftUI

/// A structure to store a users settings
public struct UserSettings: Codable, Equatable {
  public var appearanceSettings: AppearanceSettings
  public var isObservationModeEnabled: Bool
  public var showInfoViewEnabled: Bool
  public var rideEventSettings: RideEventSettings

  public init(
    appearanceSettings: AppearanceSettings = .init(),
    enableObservationMode: Bool = false,
    showInfoViewEnabled: Bool = true,
    rideEventSettings: RideEventSettings = .default
  ) {
    self.appearanceSettings = appearanceSettings
    self.isObservationModeEnabled = enableObservationMode
    self.showInfoViewEnabled = showInfoViewEnabled
    self.rideEventSettings = rideEventSettings
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    appearanceSettings = try container.decode(AppearanceSettings.self, forKey: .appearanceSettings)
    isObservationModeEnabled = try container.decode(Bool.self, forKey: .isObservationModeEnabled)
    showInfoViewEnabled = try container.decode(Bool.self, forKey: .showInfoViewEnabled)
    rideEventSettings = try container.decode(RideEventSettings.self, forKey: .rideEventSettings)
  }
}
