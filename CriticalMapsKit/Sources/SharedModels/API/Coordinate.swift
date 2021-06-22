//
//  File.swift
//  
//
//  Created by Malte on 04.06.21.
//

import CoreLocation
import Foundation

public struct Coordinate: Codable, Hashable {
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
  
  public let latitude: Double
  public let longitude: Double
}

public extension Coordinate {
  var asCLLocationCoordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}
