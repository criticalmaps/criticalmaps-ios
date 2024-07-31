import Combine
import ComposableArchitecture
import CoreLocation
import Foundation
import SharedModels

/// A client to obfuscate the users location.
/// We value privacy and to request the next ride the API does not need to know the rides exact location.
@DependencyClient
public struct CoordinateObfuscator {
  public var obfuscate: (
    _ coordinate: Coordinate,
    _ precision: ObfuscationPrecisionType
  ) -> Coordinate = {
    _,
    _ in .init(
      Location(
        coordinate: .init(latitude: 0, longitude: 0),
        timestamp: 0
      )
    )
  }
}

extension CoordinateObfuscator: DependencyKey {
  public static let liveValue =
    Self { coordinate, precisionType in
      let seededLat = coordinate.latitude + precisionType.randomInRange
      let seededLon = coordinate.longitude + precisionType.randomInRange
      return Coordinate(latitude: seededLat, longitude: seededLon)
    }
}

extension CoordinateObfuscator: TestDependencyKey {
  public static let testValue: CoordinateObfuscator = Self()
}
