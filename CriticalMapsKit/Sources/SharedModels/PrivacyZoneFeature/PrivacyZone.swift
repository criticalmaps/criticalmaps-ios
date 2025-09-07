import Foundation
import MapKit

public struct PrivacyZone: Codable, Identifiable, Equatable {
  public let id: UUID
  public let name: String
  public let center: Coordinate
  public let radius: Double // in meters
  public let isActive: Bool
  public let createdAt: Date
  
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

extension PrivacyZone {
  /// Creates a CLCircularRegion for geofencing
  public var clRegion: CLCircularRegion {
      let region = CLCircularRegion(
          center: center.asCLLocationCoordinate,
          radius: radius,
          identifier: id.uuidString
      )
      region.notifyOnEntry = true
      region.notifyOnExit = true
      return region
  }

  /// Creates an MKCircle for map visualization
  public var mkCircle: MKCircle {
      MKCircle(center: center.asCLLocationCoordinate, radius: radius)
  }

  /// Check if a coordinate is within this privacy zone
  public func contains(_ coordinate: Coordinate) -> Bool {
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
