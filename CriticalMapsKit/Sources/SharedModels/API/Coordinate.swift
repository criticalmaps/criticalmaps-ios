import CoreLocation
import Foundation

/// A structure for that parses lat and long to represent a coordinate.
public struct Coordinate: Codable, Hashable, Sendable {
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }

  public let latitude: Double
  public let longitude: Double
}

public extension Coordinate {
  init(_ location: Location) {
    latitude = location.coordinate.latitude
    longitude = location.coordinate.longitude
  }
}

public extension Coordinate {
  var asCLLocationCoordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  func distance(from coordinate: Coordinate) -> Double {
    CLLocation(self).distance(from: CLLocation(coordinate))
  }
}

public extension CLLocation {
  convenience init(_ coordinate: Coordinate) {
    self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }
}

public extension Coordinate {
  /// Formats the coordinate in the format "42,47221° N, 2,43165° W"
  var formattedForCopying: String {
    let latDirection = latitude >= 0 ? "N" : "S"
    let lonDirection = longitude >= 0 ? "E" : "W"

    let absLatitude = abs(latitude)
    let absLongitude = abs(longitude)

    return String(format: "%.5f° %@, %.5f° %@", absLatitude, latDirection, absLongitude, lonDirection)
  }
}
