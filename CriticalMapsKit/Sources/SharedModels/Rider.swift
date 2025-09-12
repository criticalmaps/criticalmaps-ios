import Foundation

/// A structure the represents a participant.
public struct Rider: Identifiable, Hashable {
  public let id: String
  public let coordinate: Coordinate
  public var timestamp: Double
  public var name: String?
  public var color: String?

  public init(
    id: String,
    coordinate: Coordinate,
    timestamp: Double,
    name: String? = nil,
    color: String? = nil
  ) {
    self.id = id
    self.coordinate = coordinate
    self.timestamp = timestamp
    self.name = name
    self.color = color
  }

  public var location: Location {
    Location(
      coordinate: coordinate,
      timestamp: timestamp,
      name: name,
      color: color
    )
  }
}

// Identity and hashing based solely on `id`
extension Rider: Equatable {
  public static func == (lhs: Rider, rhs: Rider) -> Bool {
    lhs.id == rhs.id
  }
}

extension Rider {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension Rider: Codable {
  public init(
    id: String,
    location: Location
  ) {
    self.id = id
    coordinate = location.coordinate
    timestamp = location.timestamp
    name = location.name
    color = location.color
  }

  private enum CodingKeys: String, CodingKey {
    case device
    case longitude
    case latitude
    case timestamp
    case name
    case color
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    try id = container.decode(String.self, forKey: .device)
    let latitude = try container.decode(
      Double.self,
      forKey: .latitude
    ) / locationFactor
    let longitude = try container.decode(
      Double.self,
      forKey: .longitude
    ) / locationFactor
    coordinate = Coordinate(latitude: latitude, longitude: longitude)
    try timestamp = container.decode(Double.self, forKey: .timestamp)
    try name = container.decodeIfPresent(String.self, forKey: .name)
    try color = container.decodeIfPresent(String.self, forKey: .color)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .device)
    try container.encode(coordinate.longitude * locationFactor, forKey: .longitude)
    try container.encode(coordinate.latitude * locationFactor, forKey: .latitude)
    try container.encode(timestamp, forKey: .timestamp)
    try container.encodeIfPresent(color, forKey: .color)
    try container.encodeIfPresent(name, forKey: .name)
  }
}

let locationFactor: Double = 1000000
