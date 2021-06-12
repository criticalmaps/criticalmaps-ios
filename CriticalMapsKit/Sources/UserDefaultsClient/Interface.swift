//
//  File.swift
//  
//
//  Created by Malte on 10.06.21.
//

import ComposableArchitecture
import Foundation
import Helpers
import SharedModels

public struct UserDefaultsClient {
  public var boolForKey: (String) -> Bool
  public var dataForKey: (String) -> Data?
  public var doubleForKey: (String) -> Double
  public var integerForKey: (String) -> Int
  public var remove: (String) -> Effect<Never, Never>
  public var setBool: (Bool, String) -> Effect<Never, Never>
  public var setData: (Data?, String) -> Effect<Never, Never>
  public var setDouble: (Double, String) -> Effect<Never, Never>
  public var setInteger: (Int, String) -> Effect<Never, Never>
  
  public var rideEventSettings: RideEventSettings? {
    try? self.dataForKey(rideEventSettingsKey)?.decoded()
  }

  public func setRideEventSettings(_ settings: RideEventSettings) -> Effect<Never, Never> {
    self.setData(try? settings.encoded(), rideEventSettingsKey)
  }
}

let rideEventSettingsKey = "rideEventSettings"
