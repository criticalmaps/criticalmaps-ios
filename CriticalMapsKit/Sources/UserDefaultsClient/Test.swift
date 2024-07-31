import ComposableArchitecture
import Foundation

extension UserDefaultsClient: TestDependencyKey {
  public static var testValue: UserDefaultsClient = Self()
  
  public static var previewValue: UserDefaultsClient = Self(
    boolForKey: { _ in false },
    dataForKey: { _ in nil },
    doubleForKey: { _ in 0 },
    integerForKey: { _ in 0 },
    stringForKey: { _ in "" },
    remove: { _ in },
    setBool: { _, _ in },
    setData: { _, _ in },
    setDouble: { _, _ in },
    setInteger: { _, _ in },
    setString: { _, _ in }
  )
}
