import Foundation

public extension IDProvider {
  static let noop = Self(
    id: { "" },
    token: { "" }
  )
}
