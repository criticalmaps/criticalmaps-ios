import ComposableArchitecture
import Foundation

/// A structure to store ride event settings
public struct RideEventSettings: Equatable, Codable {
  public var isEnabled: Bool
  public var rideEvents: [RideEvent]
  public var eventDistance: EventDistance

  public init(
    isEnabled: Bool = true,
    rideEvents: [RideEvent] = .default,
    eventDistance: EventDistance = .near
  ) {
    self.isEnabled = isEnabled
    self.rideEvents = rideEvents
    self.eventDistance = eventDistance
  }
}

public extension [RideEvent] {
  static let `default`: Self = Ride.RideType.allCases
    .map { RideEvent(rideType: $0, isEnabled: true) }
}

// MARK: - Shared

private extension URL {
  static var rideEventSettingsURL: URL {
    URL
      .applicationSupportDirectory
      .appendingPathComponent("rideEventSettings")
      .appendingPathExtension("json")
  }
}

public extension SharedKey where Self == Sharing.FileStorageKey<RideEventSettings>.Default {
  static var rideEventSettings: Self {
    Self[.fileStorage(.rideEventSettingsURL), default: RideEventSettings()]
  }
}
