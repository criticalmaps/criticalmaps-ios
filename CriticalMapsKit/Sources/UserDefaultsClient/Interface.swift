import ComposableArchitecture
import Foundation
import Helpers
import SharedModels

/// A client to interact with UserDefaults
@DependencyClient
public struct UserDefaultsClient {
  public var boolForKey: @Sendable (String) -> Bool = { _ in false }
  public var dataForKey: @Sendable (String) -> Data?
  public var doubleForKey: @Sendable (String) -> Double = { _ in .leastNonzeroMagnitude }
  public var integerForKey: @Sendable (String) -> Int = { _ in -1 }
  public var stringForKey: @Sendable (String) -> String? = { _ in nil }
  public var remove: @Sendable (String) async -> Void
  public var setBool: @Sendable (Bool, String) async -> Void
  public var setData: @Sendable (Data?, String) async -> Void
  public var setDouble: @Sendable (Double, String) async -> Void
  public var setInteger: @Sendable (Int, String) async -> Void
  public var setString: @Sendable (String, String) async -> Void

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
  
  public var getSessionID: String? {
    stringForKey(sessionIDKey)
  }

  public func setSessionID(_ value: String) async {
    await setString(value, sessionIDKey)
  }
}

// MARK: DependencyValue
extension DependencyValues {
  public var userDefaultsClient: UserDefaultsClient {
    get { self[UserDefaultsClient.self] }
    set { self[UserDefaultsClient.self] = newValue }
  }
}

let chatReadTimeIntervalKey = "chatReadTimeinterval"
let rideEventSettingsKey = "rideEventSettings"
let didShowObservationModePromptKey = "didShowObservationModePrompt"
let sessionIDKey = "sessionIDKey"
