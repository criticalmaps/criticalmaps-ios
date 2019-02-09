//
//  CoordinateBoundingBox.swift
//  Critiical Maps Watch Extension
//
//  Created by Leonard Thomas on 2/9/19.
//

import Foundation

struct CoordinateBoundingBox {
    let minCoordinate: Coordinate
    let maxCoordinate: Coordinate

    var topLeft: Coordinate {
        return Coordinate(latitude: minCoordinate.latitude, longitude: minCoordinate.longitude)
    }

    var topRight: Coordinate {
        return Coordinate(latitude: maxCoordinate.latitude, longitude: minCoordinate.longitude)
    }

    var bottomLeft: Coordinate {
        return Coordinate(latitude: minCoordinate.latitude, longitude: maxCoordinate.longitude)
    }

    var bottomRight: Coordinate {
        return Coordinate(latitude: maxCoordinate.latitude, longitude: maxCoordinate.longitude)
    }

    var center: Coordinate {
        let latitude = minCoordinate.latitude + ((maxCoordinate.latitude - minCoordinate.latitude) / 2)
        let longitude = minCoordinate.longitude + ((maxCoordinate.longitude - minCoordinate.longitude) / 2)
        return Coordinate(latitude: latitude, longitude: longitude)
    }

    static func from(coordinates: Set<Coordinate>) -> CoordinateBoundingBox {
        let orderedLatitude = coordinates.sorted { (a, b) -> Bool in
            a.latitude < b.latitude
        }
        let orderedLongitude = coordinates.sorted { (a, b) -> Bool in
            a.longitude < b.longitude
        }

        let minCoordinate = Coordinate(latitude: orderedLatitude.first!.latitude, longitude: orderedLongitude.first!.longitude)
        let maxCoordiannte = Coordinate(latitude: orderedLatitude.last!.latitude, longitude: orderedLongitude.last!.longitude)
        return CoordinateBoundingBox(minCoordinate: minCoordinate, maxCoordinate: maxCoordiannte)
    }

    func contains(coordinate: Coordinate) -> Bool {
        return coordinate.latitude >= minCoordinate.latitude &&
            coordinate.longitude >= minCoordinate.longitude &&
            coordinate.latitude <= maxCoordinate.latitude &&
            coordinate.longitude <= maxCoordinate.longitude
    }
}
