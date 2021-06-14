//
//  File.swift
//  
//
//  Created by Malte on 10.06.21.
//

import Foundation

public struct RideEventSettings: Codable {
  public init(
    isEnabled: Bool,
    typeSettings: [RideEventSettings.RideEventTypeSetting],
    radiusSettings: RideEventSettings.RideEventRadius
  ) {
    self.isEnabled = isEnabled
    self.typeSettings = typeSettings
    self.radiusSettings = radiusSettings
  }
  
    public var isEnabled: Bool
    public var typeSettings: [RideEventTypeSetting]
    public var radiusSettings: RideEventRadius
}

public extension RideEventSettings {
  struct RideEventRadius: Codable {
    public init(radius: Int, isEnabled: Bool) {
      self.radius = radius
      self.isEnabled = isEnabled
    }
    
      public var radius: Int
      public var isEnabled: Bool
  }

  struct RideEventTypeSetting: Codable {
    public init(type: Ride.RideType, isEnabled: Bool) {
      self.type = type
      self.isEnabled = isEnabled
    }
    
      public let type: Ride.RideType
      public var isEnabled: Bool
  }
  
  static let `default` = Self(
    isEnabled: true,
    typeSettings: .all,
    radiusSettings: .init(radius: 20, isEnabled: true)
  )
}

public extension Array where Element == RideEventSettings.RideEventTypeSetting {
  static let all: [RideEventSettings.RideEventTypeSetting] =
    Ride.RideType.allCases.map {
      RideEventSettings.RideEventTypeSetting(type: $0, isEnabled: true)
    }
}
