import ComposableCoreLocation
import CoreLocation
import Foundation

/// A structure for that parses lat and long to represent a coordinate.
public struct Coordinate: Codable, Hashable {
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }

  public let latitude: Double
  public let longitude: Double
}

public extension Coordinate {
  var asCLLocationCoordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  func distance(from coordinate: Coordinate) -> Double {
    CLLocation(self).distance(from: CLLocation(coordinate))
  }
}

extension CLLocation {
  convenience init(_ coordinate: Coordinate) {
    self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }
}
