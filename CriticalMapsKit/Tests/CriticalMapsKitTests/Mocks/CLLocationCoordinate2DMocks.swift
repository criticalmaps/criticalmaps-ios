//
//  File.swift
//  
//
//  Created by Malte on 07.06.21.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D {
    enum TestData {
        static let rendsburg = CLLocationCoordinate2D(latitude: 54.308547, longitude: 9.656645)
        static let alexanderPlatz = CLLocationCoordinate2D(latitude: 52.524657, longitude: 13.413939)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
