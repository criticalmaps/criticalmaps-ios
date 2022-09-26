import Foundation

// MARK: Mocks

public extension FileClient {
  public static let noop = Self(
    delete: { _ in },
    load: { _ in throw CancellationError() },
    save: { _, _ in }
  )
}
