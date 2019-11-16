//
//  BikeAnnotationController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 14.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import MapKit

class BikeAnnotation: IdentifiableAnnnotation {}

class BikeAnnotationController: AnnotationController<BikeAnnotation, BikeAnnoationView> {
    public override func setup() {
        mapView.register(annotationType: BikeAnnoationView.self)

        NotificationCenter.default.addObserver(self, selector: #selector(positionsDidChange(notification:)), name: Notification.positionOthersChanged, object: nil)
    }

    @objc private func positionsDidChange(notification: Notification) {
        guard let response = notification.object as? ApiResponse else { return }
        display(locations: response.locations)
    }

    private func display(locations: [String: Location]) {
        guard LocationManager.accessPermission == .authorized else {
            return
        }
        var unmatchedLocations = locations
        var unmatchedAnnotations: [MKAnnotation] = []
        // update existing annotations
        mapView.annotations.compactMap { $0 as? BikeAnnotation }.forEach { annotation in
            if let location = unmatchedLocations[annotation.identifier] {
                annotation.location = location
                unmatchedLocations.removeValue(forKey: annotation.identifier)
            } else {
                unmatchedAnnotations.append(annotation)
            }
        }
        let annotations = unmatchedLocations.map { BikeAnnotation(location: $0.value, identifier: $0.key) }
        mapView.addAnnotations(annotations)

        // remove annotations that no longer exist
        mapView.removeAnnotations(unmatchedAnnotations)
    }
    
    override func prepareAnnotationView(annotation: BikeAnnotation) -> BikeAnnoationView? {
        mapView.dequeueReusableAnnotationView(ofType: BikeAnnoationView.self, with: annotation)
    }
}
