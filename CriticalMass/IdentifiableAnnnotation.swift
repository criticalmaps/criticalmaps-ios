//
//  IdentifiableAnnnotation.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import MapKit

class IdentifiableAnnnotation: MKPointAnnotation {
    var identifier: String

    var location: Location {
        set {
            coordinate = CLLocationCoordinate2D(latitude: newValue.latitude, longitude: newValue.longitude)
        }
        @available(*, unavailable)
        get {
            fatalError("Not implemented")
        }
    }

    init(location: Location, identifier: String) {
        self.identifier = identifier
        super.init()
        self.location = location
    }
}
