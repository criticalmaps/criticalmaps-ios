//
//  BikeAnnotationView.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/18/19.
//

import MapKit

class BikeAnnoationView: MKAnnotationView {
    static let identifier = "BikeAnnotationView"

    var isFriend: Bool = false {
        didSet {
            updateImage()
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        updateImage()
        canShowCallout = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func updateImage() {
        image = isFriend ? UIImage(named: "Punk") : UIImage(named: "Bike")
    }
}
