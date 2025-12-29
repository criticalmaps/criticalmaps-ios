import Foundation

public enum AppIcon: String, Codable, CaseIterable, Hashable {
  case appIcon1 = "appIcon-1"
  case appIcon2 = "appIcon-2"
  case appIcon3 = "appIcon-3"
  case appIcon4 = "appIcon-4"
  case appIcon5 = "appIcon-5"
}

extension AppIcon: Sendable, Identifiable {
  public var id: String { rawValue }
}
