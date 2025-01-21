import UIKit

/// Extension that offers CM styleguides from Figma
public extension UIColor {
  static var backgroundPrimary: Self {
    Self { $0.isDarkMode
      ? Self.hex(0x1A1A1A)
      : Self.white
    }
  }
  
  static var backgroundSecondary: Self {
    Self { $0.isDarkMode
      ? Self.hex(0x262626)
      : Self.hex(0xF2F2F2)
    }
  }
  
  static var backgroundTranslucent: Self {
    Self { $0.isDarkMode
      ? Self.hex(0x45474D, alpha: 0.8)
      : Self.white.withAlphaComponent(0.8)
    }
  }
  
  static var attention: Self {
    hex(0xFF3355)
  }
  
  static var attentionTranslucent: Self {
    hex(0xFF3355, alpha: 0.8)
  }
  
  static var brand500: Self {
    hex(0xFFD633)
  }
  
  static var brand600: Self {
    hex(0xF2BF30)
  }
  
  static var border: Self {
    Self { $0.isDarkMode
      ? Self.hex(0x45474D)
      : .textLight
    }
  }
  
  static var textPrimary: Self {
    Self { $0.isDarkMode
      ? Self.white
      : Self.textPrimaryLight
    }
  }
  
  static var textSecondary: Self {
    Self { $0.isDarkMode
      ? .textLight
      : Self.hex(0x45474D)
    }
  }
  
  static var textLight: Self {
    hex(0xDADCE0)
  }
  
  static var textSilent: Self {
    hex(0x909399)
  }
    
  static var twitterProfileInnerBorder: Self {
    hex(0x374052, alpha: 0.18)
  }
  
  static var translateRowBackground: Self {
    hex(0x175CE5)
  }
  
  static var cmInRowBackground: Self {
    hex(0x6ADDB6)
  }
  
  static var textPrimaryLight: Self {
    .hex(0x1A1A1A)
  }
  
  static var highlight: Self {
    .hex(0x1717E5)
  }
  
  static var twitterHighlight: Self {
    Self {
      $0.isDarkMode
        ? .brand500
        : .highlight
    }
  }
  
  static var innerBorder: Self {
    .hex(0x45474D)
  }
}

public extension UIColor {
  static func hex(_ hex: UInt, alpha: CGFloat = 1) -> Self {
    Self(
      red: CGFloat((hex & 0xFF0000) >> 16) / 255,
      green: CGFloat((hex & 0x00FF00) >> 8) / 255,
      blue: CGFloat(hex & 0x0000FF) / 255,
      alpha: alpha
    )
  }
}

extension UITraitCollection {
  var isDarkMode: Bool {
    userInterfaceStyle == .dark
  }
}
