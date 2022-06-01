import Foundation
import Styleguide
import UIKit.UIColor

public extension NSAttributedString {
  static func highlightMentionsAndTags(in string: String) -> NSAttributedString {
    let components = string.split(separator: " ")
    let attributedString = NSMutableAttributedString()

    for comp in components {
      if comp.hasPrefix("@") || comp.hasPrefix("#") {
        let compAttributed = NSAttributedString(
          string: String(comp + " "),
          attributes: [.foregroundColor: UIColor.twitterHighlight]
        )
        attributedString.append(compAttributed)
      } else {
        let compAttributed = NSAttributedString(
          string: String(comp + " "),
          attributes: [.foregroundColor: UIColor.textPrimary]
        )
        attributedString.append(compAttributed)
      }
    }
    return attributedString
  }
}
