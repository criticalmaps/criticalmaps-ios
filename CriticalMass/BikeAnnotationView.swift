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

    var isFriend: Bool = false {
        didSet {
            updateImage()
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = false
        updateImage()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func updateImage() {
        image = isFriend ? UIImage(named: "Punk") : UIImage(named: "Bike")
    }
}
