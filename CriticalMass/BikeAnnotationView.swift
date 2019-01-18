//
//  BikeAnnotationView.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/18/19.
//

import MapKit
import UIKit

class BikeAnnoationView: MKAnnotationView {
    static let identifier = "BikeAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        image = UIImage(named: "Bike")
        canShowCallout = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
