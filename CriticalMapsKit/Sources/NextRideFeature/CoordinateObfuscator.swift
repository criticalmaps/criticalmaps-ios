//
//  File.swift
//  
//
//  Created by Malte on 07.06.21.
//

import Foundation
import Combine
import CoreLocation
import SharedModels

public struct CoordinateObfuscator {
  func obfuscate(
    _ coordinate: Coordinate,
    precisionType: ObfuscationPrecisionType = .thirdDecimal
  ) -> Coordinate {
    let seededLat = coordinate.latitude + precisionType.randomInRange
    let seededLon = coordinate.longitude + precisionType.randomInRange
    return Coordinate(latitude: seededLat, longitude: seededLon)
  }
}
