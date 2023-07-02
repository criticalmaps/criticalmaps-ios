import ComposableArchitecture
import Foundation

/// A structure to store ride event settings
public struct RideEventSettings: Hashable, Codable {
  public init(
    isEnabled: Bool = true,
    typeSettings: [Ride.RideType: Bool] = .all(),
    eventDistance: EventDistance = .near
  ) {
    self.isEnabled = isEnabled
    self.typeSettings = typeSettings
    self.eventDistance = eventDistance
  }

  @BindingState public var isEnabled: Bool
  @BindingState public var typeSettings: [Ride.RideType: Bool]
  @BindingState public var eventDistance: EventDistance
}

public extension RideEventSettings {
  struct RideEventTypeSetting: Hashable, Codable, Sendable {
    public init(type: Ride.RideType, isEnabled: Bool) {
      self.type = type
      self.isEnabled = isEnabled
    }

    public let type: Ride.RideType
    public var isEnabled: Bool
  }

  static let `default` = Self(
    isEnabled: true,
    typeSettings: .all(),
    eventDistance: .near
  )
}

public extension Dictionary where Key == Ride.RideType, Value == Bool {
  static func all() -> [Ride.RideType: Bool] {
    var values = [Key: Value]()
    Ride.RideType.allCases.forEach { values[$0] = true }
    return values
  }
}
