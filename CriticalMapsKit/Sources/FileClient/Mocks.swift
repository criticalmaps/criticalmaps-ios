import Foundation

// MARK: Mocks

public extension FileClient {
  static let noop = Self(
    delete: { _ in .none },
    load: { _ in .none },
    save: { _, _ in .none }
  )
}
