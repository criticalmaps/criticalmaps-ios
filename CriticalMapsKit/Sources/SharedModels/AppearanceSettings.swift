import Foundation
import enum UIKit.UIUserInterfaceStyle

/// A structure that represents a users appearance settings.
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
