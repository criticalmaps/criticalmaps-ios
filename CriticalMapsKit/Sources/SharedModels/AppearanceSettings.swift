import ComposableArchitecture
import Foundation
import enum UIKit.UIUserInterfaceStyle

/// A structure that represents a users appearance settings.
@ObservableState
public struct AppearanceSettings: Codable, Equatable, Sendable {
  public var appIcon: AppIcon
  public var colorScheme: ColorScheme = .system

  public init(
    appIcon: AppIcon = .primary,
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
    appIcon = try container.decodeIfPresent(AppIcon.self, forKey: .appIcon) ?? .primary
    colorScheme = try container.decodeIfPresent(ColorScheme.self, forKey: .colorScheme) ?? .system
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
        .unspecified
      case .dark:
        .dark
      case .light:
        .light
      }
    }
  }
}

extension AppearanceSettings.ColorScheme: Sendable, Identifiable {
  public var id: String { rawValue }
}

private extension URL {
  static var appearanceSettingsURL: URL {
    URL
      .applicationSupportDirectory
      .appendingPathComponent("appearanceSettings")
      .appendingPathExtension("json")
  }
}

public extension SharedKey where Self == FileStorageKey<AppearanceSettings>.Default {
  static var appearanceSettings: Self {
    Self[.fileStorage(.appearanceSettingsURL), default: AppearanceSettings()]
  }
}
