import Foundation

public extension Bool {
  static var iOS26: Bool {
    if #available(iOS 26, *) {
      true
    } else {
      false
    }
  }
}
