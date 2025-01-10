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
  static let `default`: Self = {
    Ride.RideType.allCases
      .map { RideEvent(rideType: $0, isEnabled: true) }
  }()
}

private extension URL {
  static var rideEventSettingsURL: URL {
    URL
      .applicationSupportDirectory
      .appendingPathComponent("rideEventSettings")
      .appendingPathExtension("json")
  }
}

extension SharedKey where Self == Sharing.FileStorageKey<RideEventSettings> {
  public static var rideEventSettings: Self {
    fileStorage(.rideEventSettingsURL)
  }
}
