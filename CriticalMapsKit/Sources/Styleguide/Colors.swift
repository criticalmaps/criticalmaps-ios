import UIKit

public extension UIColor {
  static var backgroundPrimary: Self {
    Self { $0.isDarkMode
      ? Self.hex(0x1A1A1A)
      : Self.white
    }
  }
  
  static var backgroundSecondary: Self {
    Self { $0.isDarkMode
      ? Self.hex(0x45474D, alpha: 0.8)
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
    Self.hex(0xFF3355)
  }
  
  static var attentionTranslucent: Self {
    Self.hex(0xFF3355, alpha: 0.8)
  }
  
  static var brand500: Self {
    Self.hex(0xFFD633)
  }
  
  static var brand600: Self {
    Self.hex(0xF2BF30)
  }
  
  static var border: Self {
    Self { $0.isDarkMode
      ? Self.hex(0x45474D)
      : Self.hex(0xDADCE0)
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
      ? Self.hex(0xDADCE0)
      : Self.hex(0x45474D)
    }
  }
  
  static var textSilent: Self {
    Self.hex(0x909399)
  }
    
  static var twitterProfileInnerBorder: Self {
    Self.hex(0x374052, alpha: 0.18)
  }
  
  static var translateRowBackground: Self {
    Self.hex(0x175CE5)
  }
  
  static var cmInRowBackground: Self {
    Self.hex(0xB8E5D6)
  }
  
  static var textPrimaryLight: Self {
    .hex(0x1A1A1A)
  }
}

extension UIColor {
  static func hex(_ hex: UInt, alpha: CGFloat = 1) -> Self {
    Self(
      red: CGFloat((hex & 0xff0000) >> 16) / 255,
      green: CGFloat((hex & 0x00ff00) >> 8) / 255,
      blue: CGFloat(hex & 0x0000ff) / 255,
      alpha: alpha
    )
  }
}

extension UITraitCollection {
  var isDarkMode: Bool {
    userInterfaceStyle == .dark
  }
}
