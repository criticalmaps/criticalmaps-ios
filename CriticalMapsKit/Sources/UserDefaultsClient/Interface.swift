import ComposableArchitecture
import Foundation
import Helpers
import SharedModels

/// A client to interact with UserDefaults
public struct UserDefaultsClient {
  public init(
    boolForKey: @escaping (String) -> Bool,
    dataForKey: @escaping (String) -> Data?,
    doubleForKey: @escaping (String) -> Double,
    integerForKey: @escaping (String) -> Int,
    remove: @escaping (String) -> Effect<Never, Never>,
    setBool: @escaping (Bool, String) -> Effect<Never, Never>,
    setData: @escaping (Data?, String) -> Effect<Never, Never>,
    setDouble: @escaping (Double, String) -> Effect<Never, Never>,
    setInteger: @escaping (Int, String) -> Effect<Never, Never>
  ) {
    self.boolForKey = boolForKey
    self.dataForKey = dataForKey
    self.doubleForKey = doubleForKey
    self.integerForKey = integerForKey
    self.remove = remove
    self.setBool = setBool
    self.setData = setData
    self.setDouble = setDouble
    self.setInteger = setInteger
  }
  
  public var boolForKey: (String) -> Bool
  public var dataForKey: (String) -> Data?
  public var doubleForKey: (String) -> Double
  public var integerForKey: (String) -> Int
  public var remove: (String) -> Effect<Never, Never>
  public var setBool: (Bool, String) -> Effect<Never, Never>
  public var setData: (Data?, String) -> Effect<Never, Never>
  public var setDouble: (Double, String) -> Effect<Never, Never>
  public var setInteger: (Int, String) -> Effect<Never, Never>
  
  /// Convenience getter for rideEvents
  public var rideEventSettings: () -> RideEventSettings {
    guard let data = self.dataForKey(rideEventSettingsKey) else {
      return { .default }
    }
    return { (try? data.decoded()) ?? .default }
  }

  /// Convenience setter for rideEvents
  public func setRideEventSettings(_ settings: RideEventSettings) -> Effect<Never, Never> {
    self.setData(try? settings.encoded(), rideEventSettingsKey)
  }
  
  /// Convenience getter for chat read timeinterval
  public var chatReadTimeInterval: () -> Double {
    { self.doubleForKey(chatReadTimeIntervalKey) }
  }

  /// Convenience setter for chat read timeinterval
  public func setChatReadTimeInterval(_ timeInterval: Double) -> Effect<Never, Never> {
    self.setDouble(timeInterval, chatReadTimeIntervalKey)
  }
}

let chatReadTimeIntervalKey = "chatReadTimeinterval"
let rideEventSettingsKey = "rideEventSettings"
