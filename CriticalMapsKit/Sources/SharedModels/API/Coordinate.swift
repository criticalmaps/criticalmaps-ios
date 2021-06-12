//
//  File.swift
//  
//
//  Created by Malte on 04.06.21.
//

import Foundation

public struct Coordinate: Codable, Hashable {
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
  
  public let latitude: Double
  public let longitude: Double
}
