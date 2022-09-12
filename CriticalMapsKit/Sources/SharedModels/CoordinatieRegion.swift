import CoreLocation
import Foundation
import MapKit

/// A structure for region data
public struct CoordinateRegion: Equatable {
  public var center: CLLocationCoordinate2D
  public var span: MKCoordinateSpan

  public init(
    center: CLLocationCoordinate2D,
    span: MKCoordinateSpan = .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
  ) {
    self.center = center
    self.span = span
  }

  public init(coordinateRegion: MKCoordinateRegion) {
    center = coordinateRegion.center
    span = coordinateRegion.span
  }

  public var asMKCoordinateRegion: MKCoordinateRegion {
    .init(center: center, span: span)
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.center.latitude == rhs.center.latitude
      && lhs.center.longitude == rhs.center.longitude
      && lhs.span.latitudeDelta == rhs.span.latitudeDelta
      && lhs.span.longitudeDelta == rhs.span.longitudeDelta
  }
}
