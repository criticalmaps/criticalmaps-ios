import ComposableArchitecture
import Foundation

public extension UserDefaultsClient {
  static let noop = Self(
    boolForKey: { _ in return false },
    dataForKey: { _ in return nil },
    doubleForKey: { _ in return Double.leastNonzeroMagnitude },
    integerForKey: { _ in return  -1 },
    remove: { _ in return .none },
    setBool: { _, _ in return .none },
    setData: { _, _ in return .none },
    setDouble: { _, _ in return .none },
    setInteger: { _, _ in return .none }
  )
}
