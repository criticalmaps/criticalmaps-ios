import Foundation
import MapKit
import SharedModels

/// A client to update rider annotations on a map.
@MainActor
public enum RiderAnnotationUpdateClient {
  /// Calculates the difference between displayed annotations and a collection of new rider elements.
  ///
  /// - Parameters:
  ///   - riderCoordinates: Collection of rider elements that should be displayed
  ///   - mapView: A MapView in which the annotations should be displayed
  /// - Returns: A tuple containing annotations that should be added and removed
  public static func update(
    _ riderCoordinates: [Rider],
    _ mapView: MKMapView
  )
    -> (
      removedAnnotations: [RiderAnnotation],
      addedAnnotations: [RiderAnnotation]
    )
  {
    let currentlyDisplayedPOIs = mapView.annotations.compactMap { $0 as? RiderAnnotation }
      .map(\.rider)
    
    // Riders that should be added
    let addedRider = Set(riderCoordinates).subtracting(currentlyDisplayedPOIs)
    // Riders that are not on the map anymore
    let removedRider = Set(currentlyDisplayedPOIs).subtracting(riderCoordinates)
    
    let addedAnnotations = addedRider.map(RiderAnnotation.init(rider:))
    // Annotations that should be removed
    let removedAnnotations = mapView.annotations
      .compactMap { $0 as? RiderAnnotation }
      .filter { removedRider.contains($0.rider) }
    
    return (removedAnnotations, addedAnnotations)
  }
}
