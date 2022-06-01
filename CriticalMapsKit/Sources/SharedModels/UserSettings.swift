import Foundation
import SwiftUI

/// A structure to store a users settings
public struct UserSettings: Codable, Equatable {
  public var appearanceSettings: AppearanceSettings
  public var enableObservationMode: Bool
  public var rideEventSettings: RideEventSettings

  public init(
    appearanceSettings: AppearanceSettings = .init(),
    enableObservationMode: Bool = false,
    rideEventSettings: RideEventSettings = .default
  ) {
    self.appearanceSettings = appearanceSettings
    self.enableObservationMode = enableObservationMode
    self.rideEventSettings = rideEventSettings
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    appearanceSettings = (try? container.decode(AppearanceSettings.self, forKey: .appearanceSettings)) ?? .init(colorScheme: .system)
    enableObservationMode = (try? container.decode(Bool.self, forKey: .enableObservationMode)) ?? false
    rideEventSettings = (try? container.decode(RideEventSettings.self, forKey: .rideEventSettings)) ?? .default
  }
}
