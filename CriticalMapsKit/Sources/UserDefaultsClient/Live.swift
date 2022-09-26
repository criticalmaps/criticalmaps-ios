import Foundation

public extension UserDefaultsClient {
  static func live(
    userDefaults: @autoclosure @escaping () -> UserDefaults = UserDefaults(
      suiteName: "group.criticalMaps"
    )!
  ) -> Self {
    Self(
      boolForKey: { userDefaults().bool(forKey: $0) },
      dataForKey: { userDefaults().data(forKey: $0) },
      doubleForKey: { userDefaults().double(forKey: $0) },
      integerForKey: { userDefaults().integer(forKey: $0) },
      remove: { userDefaults().removeObject(forKey: $0) },
      setBool: { userDefaults().set($0, forKey: $1) },
      setData: { userDefaults().set($0, forKey: $1) },
      setDouble: { userDefaults().set($0, forKey: $1) },
      setInteger: { userDefaults().set($0, forKey: $1) }
    )
  }
}
