//
//  File.swift
//  
//
//  Created by Malte on 07.06.21.
//

import Foundation
import Combine
import CoreLocation

public struct CoordinateObfuscator {
  func obfuscate(
    _ coordinate: CLLocationCoordinate2D,
    precisionType: ObfuscationPrecisionType = .thirdDecimal
  ) -> AnyPublisher<CLLocationCoordinate2D, Never> {
    let seededLat = coordinate.latitude + precisionType.randomInRange
    let seededLon = coordinate.longitude + precisionType.randomInRange
    return Just(CLLocationCoordinate2D(latitude: seededLat, longitude: seededLon))
      .eraseToAnyPublisher()
  }
}
