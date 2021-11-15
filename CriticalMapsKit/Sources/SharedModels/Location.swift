//
//  File.swift
//  
//
//  Created by Malte on 04.06.21.
//

import Foundation

/// Rider location with a coordinate and timestamp
public struct Location: Equatable, Hashable {
  public let coordinate: Coordinate
  public var timestamp: Double
  public var name: String?
  public var color: String?
  
  public init(
    coordinate: Coordinate,
    timestamp: Double,
    name: String? = nil,
    color: String? = nil
  ) {
    self.coordinate = coordinate
    self.timestamp = timestamp
    self.name = name
    self.color = color
  }
}

extension Location: Codable {
  private enum CodingKeys: String, CodingKey {
    case longitude
    case latitude
    case timestamp
    case name
    case color
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let latitude = try container.decode(Double.self, forKey: .latitude) / 1_000_000
    let longitude = try container.decode(Double.self, forKey: .longitude) / 1_000_000
    coordinate = Coordinate(latitude: latitude, longitude: longitude)
    try timestamp = container.decode(Double.self, forKey: .timestamp)
    try name = container.decodeIfPresent(String.self, forKey: .name)
    try color = container.decodeIfPresent(String.self, forKey: .color)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(coordinate.longitude * 1_000_000, forKey: .longitude)
    try container.encode(coordinate.latitude * 1_000_000, forKey: .latitude)
    try container.encode(timestamp, forKey: .timestamp)
    try container.encodeIfPresent(color, forKey: .color)
    try container.encodeIfPresent(name, forKey: .name)
  }
}
