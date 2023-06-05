import ComposableArchitecture
import Foundation
import Helpers
import SharedModels

/// A client to interact with UserDefaults
public struct UserDefaultsClient {
  public var boolForKey: @Sendable (String) -> Bool
  public var dataForKey: @Sendable (String) -> Data?
  public var doubleForKey: @Sendable (String) -> Double
  public var integerForKey: @Sendable (String) -> Int
  public var remove: @Sendable (String) async -> Void
  public var setBool: @Sendable (Bool, String) async -> Void
  public var setData: @Sendable (Data?, String) async -> Void
  public var setDouble: @Sendable (Double, String) async -> Void
  public var setInteger: @Sendable (Int, String) async -> Void

  /// Convenience getter for chat read timeinterval
  public var chatReadTimeInterval: Double {
    doubleForKey(chatReadTimeIntervalKey)
  }

  /// Convenience setter for chat read timeinterval
  public func setChatReadTimeInterval(_ timeInterval: Double) async {
    await setDouble(timeInterval, chatReadTimeIntervalKey)
  }

  public var didShowObservationModePrompt: Bool {
    boolForKey(didShowObservationModePromptKey)
  }

  public func setDidShowObservationModePrompt(_ value: Bool) async {
    await setBool(value, didShowObservationModePromptKey)
  }
}

let chatReadTimeIntervalKey = "chatReadTimeinterval"
let rideEventSettingsKey = "rideEventSettings"
let didShowObservationModePromptKey = "didShowObservationModePrompt"
