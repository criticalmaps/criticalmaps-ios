import Foundation
import SwiftUI

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
    self.appearanceSettings = (try? container.decode(AppearanceSettings.self, forKey: .appearanceSettings)) ?? .init(colorScheme: .system)
    self.enableObservationMode = (try? container.decode(Bool.self, forKey: .enableObservationMode)) ?? false
    self.rideEventSettings = (try? container.decode(RideEventSettings.self, forKey: .rideEventSettings)) ?? .default
  }
}

public enum AppIcon: String, Codable, CaseIterable, Hashable {
  case appIcon1 = "appIcon-1"
  case appIcon2 = "appIcon-2"
  case appIcon3 = "appIcon-3"
  case appIcon4 = "appIcon-4"
  case appIcon5 = "appIcon-5"
}

// MARK: AppearanceSettings
public struct AppearanceSettings: Codable, Equatable {
  public var appIcon: AppIcon?
  public var colorScheme: ColorScheme
  
  public init(appIcon: AppIcon? = .appIcon2, colorScheme: ColorScheme = .system) {
    self.appIcon = appIcon
    self.colorScheme = colorScheme
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.appIcon = (try? container.decode(AppIcon.self, forKey: .appIcon)) ?? .appIcon2
    self.colorScheme = (try? container.decode(ColorScheme.self, forKey: .colorScheme)) ?? .system
  }
}

public extension AppearanceSettings {
  enum ColorScheme: String, CaseIterable, Codable {
    case system
    case dark
    case light

    public var userInterfaceStyle: UIUserInterfaceStyle {
      switch self {
      case .system:
        return .unspecified
      case .dark:
        return .dark
      case .light:
        return .light
      }
    }
  }
}
