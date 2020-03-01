//
//  IdentifiableAnnotationTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 27.02.20.
//  Copyright © 2020 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import MapKit
import XCTest

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

class IdentifiableAnnotationTests: XCTestCase {
    func testSetCoordianteOnInit() {
        let location = Location(longitude: 42, latitude: 42, timestamp: 0, name: nil, color: nil)

        let annotation = IdentifiableAnnnotation(location: location, identifier: "foo")

        XCTAssertEqual(annotation.coordinate, CLLocationCoordinate2D(latitude: 42, longitude: 42))
    }
}
