import Combine
import CoreLocation
import Foundation
import SharedModels

/// A client to obfuscate the users location.
/// We value privacy and to request the next ride the API does not need to know the rides exact location.
public struct CoordinateObfuscator {
  public var obfuscate: (Coordinate, ObfuscationPrecisionType) -> Coordinate
}

public extension CoordinateObfuscator {
  static let live =
    Self { coordinate, precisionType in
      let seededLat = coordinate.latitude + precisionType.randomInRange
      let seededLon = coordinate.longitude + precisionType.randomInRange
      return Coordinate(latitude: seededLat, longitude: seededLon)
    }
}
