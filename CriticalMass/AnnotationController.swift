//
//  AnnotationController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 15.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import MapKit

class AnnotationController<T: IdentifiableAnnnotation<J>, K: AnnotationView, J> {
    var mapView: MKMapView
    let annotationType = T.self
    let annotationViewType = K.self

    required init(mapView: MKMapView) {
        self.mapView = mapView
        setup()
    }

    open func setup() {}

    /// This method updates the displayed Annotations of the annotationType T. Annotations that already have a AnnotationView are updated with a new location, Annotations that don't have a View yet, will be added, and previously displayed annotations of the given type will be removed from the Map
    /// - Parameter locations: A dictionary mapping between  identifier and their locations
    open func updateAnnotations(locations: [String: (location: Location, object: J?)]) {
        var unmatchedLocations = locations
        var unmatchedAnnotations: [MKAnnotation] = []
        // update existing annotations
        mapView.annotations.compactMap { $0 as? T }.forEach { annotation in
            if let value = unmatchedLocations[annotation.identifier] {
                annotation.location = value.location
                unmatchedLocations.removeValue(forKey: annotation.identifier)
            } else {
                unmatchedAnnotations.append(annotation)
            }
        }

        let annotations = unmatchedLocations.map { T(location: $0.value.location, identifier: $0.key, object: $0.value.object) }
        mapView.addAnnotations(annotations)

        // remove annotations that no longer exist
        mapView.removeAnnotations(unmatchedAnnotations)
    }
}
