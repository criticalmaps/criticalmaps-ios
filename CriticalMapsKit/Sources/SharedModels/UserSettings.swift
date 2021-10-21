//
//  File.swift
//  
//
//  Created by Malte on 13.08.21.
//

import Foundation
import SwiftUI

public struct UserSettings: Codable, Equatable {
  public var appIcon: AppIcon?
  public var colorScheme: ColorScheme
  public var enableObservationMode: Bool
  public var rideEventSettings: RideEventSettings
  
  public init(
    appIcon: AppIcon? = nil,
    colorScheme: ColorScheme = .system,
    enableObservationMode: Bool = false,
    rideEventSettings: RideEventSettings = .default
  ) {
    self.appIcon = appIcon
    self.colorScheme = colorScheme
    self.enableObservationMode = enableObservationMode
    self.rideEventSettings = rideEventSettings
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.appIcon = try? container.decode(AppIcon.self, forKey: .appIcon)
    self.colorScheme = (try? container.decode(ColorScheme.self, forKey: .colorScheme)) ?? .system
    self.enableObservationMode = (try? container.decode(Bool.self, forKey: .enableObservationMode)) ?? false
    self.rideEventSettings = (try? container.decode(RideEventSettings.self, forKey: .rideEventSettings)) ?? .default
  }
}

public extension UserSettings {
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

public enum AppIcon: String, Codable, CaseIterable, Hashable {
  case appIcon1 = "appIcon-1"
  case appIcon2 = "appIcon-2"
  case appIcon3 = "appIcon-3"
  case appIcon4 = "appIcon-4"
  case appIcon5 = "appIcon-5"
}
