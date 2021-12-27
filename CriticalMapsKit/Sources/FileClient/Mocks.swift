import Foundation

// MARK: Mocks
extension FileClient {
  public static let noop = Self(
    delete: { _ in .none },
    load: { _ in .none },
    save: { _, _ in .none }
  )
}
