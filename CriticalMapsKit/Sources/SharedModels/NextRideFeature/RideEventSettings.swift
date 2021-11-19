import Foundation

public struct RideEventSettings: Hashable, Codable {
  public init(
    isEnabled: Bool,
    typeSettings: [RideEventSettings.RideEventTypeSetting],
    radiusSettings: Int
  ) {
    self.isEnabled = isEnabled
    self.typeSettings = typeSettings
    self.radiusSettings = radiusSettings
  }
  
    public var isEnabled: Bool
    public var typeSettings: [RideEventTypeSetting]
    public var radiusSettings: Int
}

public extension RideEventSettings {
  struct RideEventTypeSetting: Hashable, Codable {
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
    radiusSettings: Ride.eventRadii[1]
  )
}

public extension Array where Element == RideEventSettings.RideEventTypeSetting {
  static let all: [RideEventSettings.RideEventTypeSetting] =
    Ride.RideType.allCases.map {
      RideEventSettings.RideEventTypeSetting(type: $0, isEnabled: true)
    }
}
