import CoreLocation
import Foundation
import MapKit
import SharedModels

/// Map annotation to annotate the next ride on a map.
public final class CriticalMassAnnotation: NSObject, MKAnnotation {
  public let ride: Ride
  let rideCoordinate: Coordinate

  public init?(ride: Ride) {
    guard let rideCoordinate = ride.coordinate else {
      return nil
    }
    self.rideCoordinate = rideCoordinate
    self.ride = ride
    super.init()
  }

  public var title: String? {
    ride.titleAndTime
  }

  @objc public dynamic var coordinate: CLLocationCoordinate2D {
    rideCoordinate.asCLLocationCoordinate
  }

  public var subtitle: String? {
    ride.location
  }
}
