//
//  IdentifiableAnnnotation.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import MapKit

class IdentifiableAnnnotation: MKPointAnnotation {
    enum UserType: Int, Decodable {
        case friend
        case user
    }

    var type: UserType = .user
    var identifier: String

    var location: Location {
        didSet {
            coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }

    init(location: Location, identifier: String) {
        self.identifier = identifier
        self.location = location
        super.init()
    }
}
