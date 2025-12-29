import Foundation

public enum AppIcon: String, Codable, CaseIterable, Hashable {
  case primary = "AppIcon"
  case dark = "AppIcon-Dark"
  case neon = "AppIcon-Neon"
  case rainbow = "AppIcon-Rainbow"
  case sun = "AppIcon-Sun"
}

extension AppIcon: Sendable, Identifiable {
  public var id: String { rawValue }
}
