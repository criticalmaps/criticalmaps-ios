import ComposableArchitecture
import Foundation

@ObservableState
public struct RideEvent: Equatable, Identifiable, Codable, Sendable {
  public var id: String {
    rideType.rawValue
  }

  public let rideType: Ride.RideType
  public var isEnabled = true

  public init(rideType: Ride.RideType, isEnabled: Bool) {
    self.rideType = rideType
    self.isEnabled = isEnabled
  }
}
