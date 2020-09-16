//
//  MKMapView+Register.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 14.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import MapKit

extension MKAnnotationView {
    class var reuseIdentifier: String {
        String(describing: self)
    }
}

extension MKMapView {
    func register<T: MKAnnotationView>(annotationViewType: T.Type) {
        register(annotationViewType, forAnnotationViewWithReuseIdentifier: annotationViewType.reuseIdentifier)
    }

    func dequeueReusableAnnotationView<T: MKAnnotationView>(ofType annotationType: T.Type, for _: IndexPath? = nil, with annotation: MKAnnotation) -> T {
        let annotationView: T
        annotationView = dequeueReusableAnnotationView(withIdentifier: annotationType.reuseIdentifier, for: annotation) as! T
        return annotationView
    }
}
