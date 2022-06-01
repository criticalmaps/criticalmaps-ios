import ComposableArchitecture
import Foundation

public extension UserDefaultsClient {
  static let noop = Self(
    boolForKey: { _ in false },
    dataForKey: { _ in nil },
    doubleForKey: { _ in Double.leastNonzeroMagnitude },
    integerForKey: { _ in -1 },
    remove: { _ in .none },
    setBool: { _, _ in .none },
    setData: { _, _ in .none },
    setDouble: { _, _ in .none },
    setInteger: { _, _ in .none }
  )
}
