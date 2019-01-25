//
//  Location+CoreLocation.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/18/19.
//

import CoreLocation

extension Location {
    init(_ clLocation: CLLocation, name: String? = nil, color: String? = nil) {
        longitude = clLocation.coordinate.longitude
        latitude = clLocation.coordinate.latitude
        timestamp = Float(clLocation.timestamp.timeIntervalSince1970)
        self.name = name
        self.color = color
    }
}

extension CLLocationCoordinate2D {
    init(_ location: Location) {
        self.init()
        longitude = location.longitude
        latitude = location.latitude
    }
}
