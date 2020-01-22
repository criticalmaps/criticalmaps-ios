//
//  AnnotationController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 15.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import MapKit

class AnnotationController {
    typealias AnnotationType = MKAnnotation.Type
    typealias AnnotationViewType = MKAnnotationView.Type

    let mapView: MKMapView
    let annotationType: AnnotationType
    let annotationViewType: AnnotationViewType

    required init(
        mapView: MKMapView,
        annotationType: AnnotationType,
        annotationViewType: AnnotationViewType
    ) {
        self.mapView = mapView
        self.annotationType = annotationType
        self.annotationViewType = annotationViewType
        setup()
    }

    open func setup() {}
}
