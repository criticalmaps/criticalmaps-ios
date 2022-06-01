import Foundation

/// A structure to store ride event settings
public struct RideEventSettings: Hashable, Codable {
  public init(
    isEnabled: Bool,
    typeSettings: [RideEventSettings.RideEventTypeSetting],
    eventDistance: EventDistance
  ) {
    self.isEnabled = isEnabled
    self.typeSettings = typeSettings
    self.eventDistance = eventDistance
  }

  public var isEnabled: Bool
  public var typeSettings: [RideEventTypeSetting]
  public var eventDistance: EventDistance
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
    eventDistance: .near
  )
}

public extension Array where Element == RideEventSettings.RideEventTypeSetting {
  static let all: [RideEventSettings.RideEventTypeSetting] =
    Ride.RideType.allCases.map {
      RideEventSettings.RideEventTypeSetting(type: $0, isEnabled: true)
    }
}
