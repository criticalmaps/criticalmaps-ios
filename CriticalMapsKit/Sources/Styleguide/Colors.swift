import UIKit

public extension UIColor {
  static var backgroundPrimary: Self {
    Self { $0.isDarkMode
      ? .hex(0x1A1A1A)
      : .white
    }
  }
  
  static var backgroundSecondary: Self {
    Self { $0.isDarkMode
      ? .hex(0x45474D, alpha: 0.8)
      : .hex(0xF2F2F2)
    }
  }
  
  static var backgroundTranslucent: Self {
    Self { $0.isDarkMode
      ? .hex(0x45474D, alpha: 0.8)
      : .white.withAlphaComponent(0.8)
    }
  }
  
  static var attention: Self {
    .hex(0xFF3355)
  }
  
  static var attentionTranslucent: Self {
    .hex(0xFF3355, alpha: 0.8)
  }
  
  static var brand500: Self {
    .hex(0xFFD633)
  }
  
  static var brand600: Self {
    .hex(0xF2BF30)
  }
  
  static var border: Self {
    Self { $0.isDarkMode
      ? .hex(0x45474D)
      : .hex(0xDADCE0)
    }
  }
  
  static var textPrimary: Self {
    Self { $0.isDarkMode
      ? .white
      : .hex(0x1A1A1A)
    }
  }
  
  static var textSecondary: Self {
    Self { $0.isDarkMode
      ? .hex(0xDADCE0)
      : .hex(0x45474D)
    }
  }
  
  static var textSilent: Self {
    .hex(0x909399)
  }
    
  static var twitterProfileInnerBorder: Self {
    .hex(0x374052, alpha: 0.18)
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
