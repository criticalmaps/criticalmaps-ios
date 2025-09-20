import Foundation
import MapKit

public struct PrivacyZone: Codable, Identifiable, Equatable {
  public let id: UUID
  public let name: String
  public let center: Coordinate
  public let radius: Double // in meters
  public var isActive: Bool
  public let createdAt: Date

  public var radiusMeasurement: Measurement<UnitLength> {
    Measurement<UnitLength>(value: radius, unit: .meters)
  }

  public init(
    id: UUID = UUID(),
    name: String,
    center: Coordinate,
    radius: Double,
    isActive: Bool = true,
    createdAt: Date = Date()
  ) {
    self.id = id
    self.name = name
    self.center = center
    self.radius = radius
    self.isActive = isActive
    self.createdAt = createdAt
  }
}

public extension PrivacyZone {
  /// Creates a CLCircularRegion for geofencing
  var clRegion: CLCircularRegion {
    let region = CLCircularRegion(
      center: center.asCLLocationCoordinate,
      radius: radius,
      identifier: id.uuidString
    )
    region.notifyOnEntry = true
    region.notifyOnExit = true
    return region
  }

  /// Creates an MKCircle for map visualisation
  var mkCircle: MKCircle {
    MKCircle(center: center.asCLLocationCoordinate, radius: radius)
  }

  /// Check if a coordinate is within this privacy zone
  func contains(_ coordinate: Coordinate) -> Bool {
    let zoneLocation = CLLocation(
      latitude: center.latitude,
      longitude: center.longitude
    )
    let testLocation = CLLocation(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude
    )

    return zoneLocation.distance(from: testLocation) <= radius
  }
}
