import Foundation

public enum AppIcon: String, Codable, CaseIterable, Hashable, Identifiable {
  case primary = "AppIcon"
  case dark = "AppIcon-Dark"
  case neon = "AppIcon-Neon"
  case rainbow = "AppIcon-Rainbow"
  case sun = "AppIcon-Sun"

  public var id: String { rawValue }
}
