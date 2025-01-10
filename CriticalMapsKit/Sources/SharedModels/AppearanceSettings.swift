import ComposableArchitecture
import Foundation
import enum UIKit.UIUserInterfaceStyle

/// A structure that represents a users appearance settings.
@ObservableState
public struct AppearanceSettings: Codable, Equatable {
  public var appIcon: AppIcon = .appIcon2
  public var colorScheme: ColorScheme = .system

  public init(
    appIcon: AppIcon = .appIcon2,
    colorScheme: ColorScheme = .system
  ) {
    self.appIcon = appIcon
    self.colorScheme = colorScheme
  }

  enum CodingKeys: CodingKey {
    case appIcon
    case colorScheme
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.appIcon = try container.decodeIfPresent(AppIcon.self, forKey: .appIcon) ?? .appIcon2
    self.colorScheme = try container.decodeIfPresent(ColorScheme.self, forKey: .colorScheme) ?? .system
  }
  
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(appIcon, forKey: .appIcon)
    try container.encode(colorScheme, forKey: .colorScheme)
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

private extension URL {
  static var appearanceSettingsURL: URL {
    URL
      .applicationSupportDirectory
      .appendingPathComponent("appearanceSettings")
      .appendingPathExtension("json")
  }
}

extension SharedKey
where Self == Sharing.FileStorageKey<AppearanceSettings> {
  public static var appearanceSettings: Self {
    fileStorage(.appearanceSettingsURL)
  }
}
