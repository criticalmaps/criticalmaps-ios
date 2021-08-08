//
//  File.swift
//  
//
//  Created by Malte on 15.06.21.
//

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
  
  //--
  static var gray100: UIColor {
    UIColor(white: 26.0 / 255.0, alpha: 1.0)
  }
  
  static var gray200: UIColor {
    UIColor(white: 38.0 / 255.0, alpha: 1)
  }
  
  static var gray300: UIColor {
    UIColor(red: 69.0 / 255.0, green: 71.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
  }
  
  static var gray400: UIColor {
    UIColor(red: 144 / 255.0, green: 147 / 255.0, blue: 153 / 255.0, alpha: 1)
  }
  
  static var gray500: UIColor {
    UIColor(red: 218.0 / 255.0, green: 220.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0)
  }
  
  static var settingsOpenSourceForeground: UIColor {
    UIColor(white: 26.0 / 255.0, alpha: 1)
  }
  
  static var navigationOverlayBackground: UIColor {
    UIColor(white: 1.0, alpha: 0.8)
  }
  
  static var yellow100: UIColor {
    UIColor(red: 255.0 / 255.0, green: 214.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
  }
  
  static var yellow80: UIColor {
    UIColor(red: 230.0 / 255.0, green: 184.0 / 255.0, blue: 0 / 255.0, alpha: 1.0)
  }
  
  static var gray600: UIColor {
    UIColor(white: 250.0 / 255.0, alpha: 1.0)
  }
  
  static var lightThemeToolBarBackgroundColor: UIColor {
    gray600
  }
  
  static var lightThemeNavigationOverlaySeperatorColor: UIColor {
    UIColor(red: 220.0 / 255.0, green: 224.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.00)
  }
  
  static var darkThemeNavigationOverlaySeperatorColor: UIColor {
    UIColor(white: 57.0 / 255.0, alpha: 1.00)
  }
  
  static var lightThemeGradientBegin: UIColor {
    UIColor(red: 249.0 / 255.0, green: 244.0 / 255.0, blue: 236.0 / 255.0, alpha: 1.00)
  }
  
  static var lightThemeGradientEnd: UIColor {
    UIColor(red: 250.0 / 255.0, green: 245.0 / 255.0, blue: 237.0 / 255.0, alpha: 0.75)
  }
  
  static var darkThemeGradientBegin: UIColor {
    UIColor(red: 43.0 / 255.0, green: 45.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.00)
  }
  
  static var darkThemeGradientEnd: UIColor {
    UIColor(red: 43.0 / 255.0, green: 45.0 / 255.0, blue: 47.0 / 255.0, alpha: 0.75)
  }
  
  static var onlineGreen: UIColor {
    UIColor(red: 20.0 / 255.0, green: 204.0 / 255.0, blue: 51.0 / 255.0, alpha: 1)
  }
  
  static var errorRed: UIColor {
    UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 85.0 / 255.0, alpha: 1)
  }
  
  static var lightThemedSettingsPlaceholderColor: UIColor {
    UIColor(red: 216.0 / 255.0, green: 216.0 / 255.0, blue: 216.0 / 255.0, alpha: 1)
  }
  
  static var darkThemedSettingsPlaceholderColor: UIColor {
    UIColor(red: 144.0 / 255.0, green: 147.0 / 255.0, blue: 153.0 / 255.0, alpha: 1)
  }
}

extension UIColor {
  static func hex(_ hex: UInt, alpha: Double = 1) -> Self {
    Self(
      red: Double((hex & 0xff0000) >> 16) / 255,
      green: Double((hex & 0x00ff00) >> 8) / 255,
      blue: Double(hex & 0x0000ff) / 255,
      alpha: alpha
    )
  }
}

extension UITraitCollection {
  var isDarkMode: Bool {
    userInterfaceStyle == .dark
  }
}
