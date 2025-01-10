import ComposableArchitecture
import Foundation

@ObservableState
public struct RideEvent: Equatable, Identifiable, Codable {
  public var id: String {
    self.rideType.rawValue
  }
  public let rideType: Ride.RideType
  public var isEnabled = true
  
  public init(rideType: Ride.RideType, isEnabled: Bool) {
    self.rideType = rideType
    self.isEnabled = isEnabled
  }
}
