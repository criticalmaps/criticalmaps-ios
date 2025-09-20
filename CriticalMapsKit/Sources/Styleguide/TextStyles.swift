import SwiftUI

/// A extension to represent the styleguids Font styles
public extension Font {
  static let titleOne = Font.title2.weight(.medium)
  static let titleTwo = Font.subheadline.weight(.bold)
  static let bodyOne = Font.body.weight(.regular)
  static let bodyTwo = Font.subheadline.weight(.regular)
  static let meta = Font.footnote.weight(.bold)
  static let pageTitle = Font.body.weight(.semibold)
  static let headlineOne = Font.largeTitle.weight(.bold)
  static let headlineTwo = Font.title.weight(.bold)
}

public extension Text {
  init(_ astring: NSAttributedString) {
    self.init("")
    
    astring.enumerateAttributes(in: NSRange(location: 0, length: astring.length), options: []) { attrs, range, _ in      
      var t = Text(astring.attributedSubstring(from: range).string)
      
      if let color = attrs[NSAttributedString.Key.foregroundColor] as? UIColor {
        t = t.foregroundColor(Color(color))
      }
      
      if let font = attrs[NSAttributedString.Key.font] as? UIFont {
        t = t.font(.init(font))
      }
      
      if let kern = attrs[NSAttributedString.Key.kern] as? CGFloat {
        t = t.kerning(kern)
      }
      
      if let striked = attrs[NSAttributedString.Key.strikethroughStyle] as? NSNumber, striked != 0 {
        if let strikeColor = (attrs[NSAttributedString.Key.strikethroughColor] as? UIColor) {
          t = t.strikethrough(true, color: Color(strikeColor))
        } else {
          t = t.strikethrough(true)
        }
      }
      
      if let baseline = attrs[NSAttributedString.Key.baselineOffset] as? NSNumber {
        t = t.baselineOffset(CGFloat(baseline.floatValue))
      }
      
      if let underline = attrs[NSAttributedString.Key.underlineStyle] as? NSNumber, underline != 0 {
        if let underlineColor = (attrs[NSAttributedString.Key.underlineColor] as? UIColor) {
          t = t.underline(true, color: Color(underlineColor))
        } else {
          t = t.underline(true)
        }
      }
      
      self = self + t
    }
  }
}
