//
//  File.swift
//  
//
//  Created by Malte on 10.06.21.
//

import Foundation

public struct RideEventSettings: Codable {
    public var isEnabled: Bool
    public var typeSettings: [RideEventTypeSetting]
    public var radiusSettings: RideEventRadius
    public var filteredEvents: [Ride.RideType] {
        typeSettings
            .filter { !$0.isEnabled }
            .map(\.type)
    }
}

public extension RideEventSettings {
  struct RideEventRadius: Codable {
      public var radius: Int
      public var isEnabled: Bool
  }

  struct RideEventTypeSetting: Codable {
      public let type: Ride.RideType
      public var isEnabled: Bool
  }
}
