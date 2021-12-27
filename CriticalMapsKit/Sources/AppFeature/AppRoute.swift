import Foundation

/// An object to encapsulate navigation
public enum AppRoute: Equatable {
  case chat
  case rules
  case settings
  
  public enum Tag: Int {
    case chat
    case rules
    case settings
  }

  var tag: Tag {
    switch self {
    case .chat:
      return .chat
    case .rules:
      return .rules
    case .settings:
      return .settings
    }
  }
}
