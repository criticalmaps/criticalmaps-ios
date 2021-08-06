public struct Infobar: Equatable {
  public enum Style: Equatable {
    case criticalMass
    case success
    case warning
    case error
    
    var displayDuration: Int {
      switch self {
      case .criticalMass:
        return 30000
      case .success:
        return 4000
      case .warning, .error:
        return 15000
      }
    }
  }
  
  public typealias TapAction = () -> Void
  
  public let trimmedMessage: String
  public let subTitle: String?
  public let style: Style
  public let action: TapAction?
  
  private init(message: String, subTitle: String? = nil, style: Style, action: TapAction? = nil) {
    self.trimmedMessage = String(
      message
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .prefix(90)
    )
    self.subTitle = subTitle
    self.style = style
    self.action = action
  }
  
  public static func criticalMass(
    message: String,
    subTitle: String? = nil,
    action: TapAction? = nil
  ) -> Infobar {
    Infobar(message: message, subTitle: subTitle, style: .criticalMass, action: action)
  }
  
  public static func success(message: String, action: TapAction? = nil) -> Infobar {
    Infobar(message: message, style: .success, action: action)
  }
  
  public static func warning(message: String, action: TapAction? = nil) -> Infobar {
    Infobar(message: message, style: .warning, action: action)
  }
  
  public static func error(message: String, action: TapAction? = nil) -> Infobar {
    Infobar(message: message, style: .error, action: action)
  }
  
  public static func == (lhs: Infobar, rhs: Infobar) -> Bool {
    lhs.trimmedMessage == rhs.trimmedMessage && lhs.style == rhs.style
  }
}
