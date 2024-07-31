import ComposableArchitecture
import Foundation

extension UserDefaultsClient: DependencyKey {
  public static var liveValue: UserDefaultsClient {
    let userDefaults = UncheckedSendable(UserDefaults(suiteName: "group.criticalMaps")!)
    return Self(
      boolForKey: { userDefaults.value.bool(forKey: $0) },
      dataForKey: { userDefaults.value.data(forKey: $0) },
      doubleForKey: { userDefaults.value.double(forKey: $0) },
      integerForKey: { userDefaults.value.integer(forKey: $0) },
      stringForKey: { userDefaults.value.string(forKey: $0) },
      remove: { userDefaults.value.removeObject(forKey: $0) },
      setBool: { userDefaults.value.set($0, forKey: $1) },
      setData: { userDefaults.value.set($0, forKey: $1) },
      setDouble: { userDefaults.value.set($0, forKey: $1) },
      setInteger: { userDefaults.value.set($0, forKey: $1) },
      setString: { userDefaults.value.set($0, forKey: $1) }
    )
  }
}
