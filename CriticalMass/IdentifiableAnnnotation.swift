//
//  IdentifiableAnnnotation.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import MapKit

class IdentifiableAnnnotation<T>: MKPointAnnotation {
    var identifier: String
    var object: T?

    var location: Location {
        didSet {
            coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }

    required init(location: Location, identifier: String, object: T?) {
        self.identifier = identifier
        self.location = location
        self.object = object
        super.init()
    }
}
