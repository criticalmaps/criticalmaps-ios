//
//  AnnotationController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 15.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import MapKit

class AnnotationController<T: IdentifiableAnnnotation, K: MKAnnotationView> {
    var mapView: MKMapView
    let annotationType = T.self
    let annotationViewType = K.self

    required init(mapView: MKMapView) {
        self.mapView = mapView
        setup()
    }

    open func setup() {}

    open func updateAnnotations(locations: [String: Location]) {
        var unmatchedLocations = locations
        var unmatchedAnnotations: [MKAnnotation] = []
        // update existing annotations
        mapView.annotations.compactMap { $0 as? T }.forEach { annotation in
            if let location = unmatchedLocations[annotation.identifier] {
                annotation.location = location
                unmatchedLocations.removeValue(forKey: annotation.identifier)
            } else {
                unmatchedAnnotations.append(annotation)
            }
        }
        let annotations = unmatchedLocations.map { T(location: $0.value, identifier: $0.key) }
        mapView.addAnnotations(annotations)

        // remove annotations that no longer exist
        mapView.removeAnnotations(unmatchedAnnotations)
    }
}
