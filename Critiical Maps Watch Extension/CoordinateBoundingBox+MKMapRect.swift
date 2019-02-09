//
//  CoordinateBoundingBox+MKMapRect.swift
//  Critiical Maps Watch Extension
//
//  Created by Leonard Thomas on 2/9/19.
//

import MapKit

extension CoordinateBoundingBox {
    static func from(mapRect: MKMapRect) -> CoordinateBoundingBox {
        let topLeft = MKMapPoint(x: mapRect.minX, y: mapRect.maxY).coordinate
        let minCoordinate = Coordinate(latitude: topLeft.latitude, longitude: topLeft.longitude)
        let bottomRight = MKMapPoint(x: mapRect.maxX, y: mapRect.minY).coordinate
        let maxCoordinate = Coordinate(latitude: bottomRight.latitude, longitude: bottomRight.longitude)
        return CoordinateBoundingBox(minCoordinate: minCoordinate, maxCoordinate: maxCoordinate)
    }
}
