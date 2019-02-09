//
//  Coordinate.swift
//  Critiical Maps Watch Extension
//
//  Created by Leonard Thomas on 2/8/19.
//

import Foundation

struct Coordinate: Hashable {
    let latitude: Double
    let longitude: Double
}

extension Coordinate {
    func distance(to other: Coordinate) -> Double {
        func degreesToRadians(degrees: Double) -> Double {
            return degrees * Double.pi / 180
        }

        let earthRadiusKm: Double = 6371

        let deltaLatitude = degreesToRadians(degrees: other.latitude - latitude)
        let deltaLontitude = degreesToRadians(degrees: other.longitude - longitude)

        let angle = sin(deltaLatitude / 2) * sin(deltaLatitude / 2) +
            sin(deltaLontitude / 2) * sin(deltaLontitude / 2) * cos(degreesToRadians(degrees: latitude)) * cos(degreesToRadians(degrees: other.latitude))
        return earthRadiusKm * (2 * atan2(sqrt(angle), sqrt(1 - angle)))
    }
}
