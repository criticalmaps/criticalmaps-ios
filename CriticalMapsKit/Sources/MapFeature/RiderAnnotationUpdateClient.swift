import Foundation
import MapKit
import SharedModels

/// A client to update rider annotations on a map.
public enum RiderAnnotationUpdateClient {
  /// Calculates the difference between displayed annotations and a collection of new rider elements.
  ///
  /// - Parameters:
  ///   - riderCoordinates: Collection of rider elements that should be displayed
  ///   - mapView: A MapView in which the annotations should be displayed
  ///   - excludedId: Optional rider id that should be excluded from the map entirely (e.g. current user)
  /// - Returns: A tuple containing annotations that should be added and removed
  public static func update(
    _ riderCoordinates: [Rider],
    _ mapView: MKMapView,
    excludingId excludedId: String? = nil
  ) -> (
      removedAnnotations: [RiderAnnotation],
      addedAnnotations: [RiderAnnotation]
    )
  {
    // Filter out the excluded rider (e.g. current user) before computing the diff
    let incomingRiders: [Rider]
    if let excludedId {
      incomingRiders = riderCoordinates.filter { $0.id != excludedId }
    } else {
      incomingRiders = riderCoordinates
    }

    // Current annotations keyed by rider id
    let currentAnnotations = mapView.annotations.compactMap { $0 as? RiderAnnotation }
    let currentById = Dictionary(uniqueKeysWithValues: currentAnnotations.map { ($0.rider.id, $0) })

    // New riders keyed by id
    let newById = Dictionary(uniqueKeysWithValues: incomingRiders.map { ($0.id, $0) })

    let currentIds = Set(currentById.keys)
    let newIds = Set(newById.keys)

    // Determine changes by id
    let removedIds = currentIds.subtracting(newIds)
    let addedIds = newIds.subtracting(currentIds)
    let updatedIds = currentIds.intersection(newIds)

    // Update existing annotations in place (avoid churn)
    for id in updatedIds {
      if let annotation = currentById[id], let rider = newById[id] {
        annotation.location = rider.location
      }
    }

    // Build arrays for removal and addition
    let removedAnnotations = removedIds.compactMap { currentById[$0] }
    let addedAnnotations = addedIds.compactMap { newById[$0] }.map(RiderAnnotation.init(rider:))

    return (removedAnnotations, addedAnnotations)
  }
}
