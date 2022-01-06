import SwiftUI

public extension ColorSchemeContrast {
  var isIncreased: Bool {
    switch self {
    case .standard:
      return false
    case .increased:
      return true
    @unknown default:
      return false
    }
  }
}
