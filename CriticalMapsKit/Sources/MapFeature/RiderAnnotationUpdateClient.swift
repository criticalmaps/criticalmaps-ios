import Dependencies
import DependenciesMacros
import Foundation
import MapKit
import SharedModels

/// A client to update rider annotations on a map.
@MainActor
public enum RiderAnnotationUpdateClient {
  public static func update(
    _ riderCoordinates: [Rider],
    _ mapView: MKMapView,
    showActiveRidersOnly: Bool
  ) -> (
    removedAnnotations: [RiderAnnotation],
    addedAnnotations: [RiderAnnotation]
  ) {
    let currentlyDisplayedPOIs = mapView.annotations
      .compactMap { $0 as? RiderAnnotation }
      .map(\.rider)

    let addedRider = Set(riderCoordinates).subtracting(currentlyDisplayedPOIs)
    let removedRider = Set(currentlyDisplayedPOIs).subtracting(riderCoordinates)

    // Classify all riders once — O(n²) over the full set so added annotations
    // get the correct isActive relative to all current participants.
    let activeIDs = RiderActivityFilter.classify(riderCoordinates)

    let addedAnnotations = addedRider.map { rider in
      RiderAnnotation(rider: rider, isActive: activeIDs.contains(rider.id))
    }

    let removedAnnotations = mapView.annotations
      .compactMap { $0 as? RiderAnnotation }
      .filter { removedRider.contains($0.rider) }

    // Refresh isActive + isFilterActive on already-displayed annotations
    // so existing views reflect the latest classification and toggle state.
    mapView.annotations
      .compactMap { $0 as? RiderAnnotation }
      .filter { !removedRider.contains($0.rider) }
      .forEach { annotation in
        let view = mapView.view(for: annotation) as? RiderAnnotationView
        view?.isRiderActive = activeIDs.contains(annotation.rider.id)
        view?.isFilterActive = showActiveRidersOnly
      }

    return (removedAnnotations, addedAnnotations)
  }
}

public enum RiderActivityFilter {
  static let shortRangeMeters: Double = 250
  static let longRangeMeters: Double = 8000

  public static func classify(_ riders: [Rider]) -> Set<String> {
    var activeIDs = Set<String>()

    for rider in riders {
      var shortRange = 0
      var longRange = 0

      for other in riders where other.id != rider.id {
        let distance = rider.coordinate.distance(to: other.coordinate)
        if distance <= longRangeMeters { longRange += 1 }
        if distance <= shortRangeMeters { shortRange += 1 }
      }

      if isActive(shortRange: shortRange, longRange: longRange) {
        activeIDs.insert(rider.id)
      }
    }

    return activeIDs
  }

  private static func isActive(shortRange: Int, longRange: Int) -> Bool {
    shortRange >= 3
      || (shortRange >= 2 && longRange < 15)
      || (shortRange > 1 && longRange < 7)
  }
}

import CoreLocation

extension Coordinate {
  func distance(to other: Coordinate) -> CLLocationDistance {
    CLLocation(latitude: latitude, longitude: longitude)
      .distance(from: CLLocation(latitude: other.latitude, longitude: other.longitude))
  }
}
