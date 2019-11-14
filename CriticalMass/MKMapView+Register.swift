//
//  MKMapView+Register.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 14.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import MapKit

extension MKAnnotationView {
    fileprivate class var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension MKMapView {
    func register<T: MKAnnotationView>(annotationType: T.Type) {
        if #available(iOS 11.0, *) {
            register(annotationType, forAnnotationViewWithReuseIdentifier: annotationType.reuseIdentifier)
        }
    }

    
    func dequeueReusableAnnotationView<T: MKAnnotationView>(ofType annotationType: T.Type, for indexPath: IndexPath? = nil, with annotation: MKAnnotation) -> T {
        let annotationView: T
        if #available(iOS 11.0, *) {
            annotationView = dequeueReusableAnnotationView(withIdentifier: annotationType.reuseIdentifier, for: annotation) as! T
        } else {
            annotationView = dequeueReusableAnnotationView(withIdentifier: annotationType.reuseIdentifier) as? T ?? T()
            annotationView.annotation = annotation
        }
        return annotationView
    }

}

