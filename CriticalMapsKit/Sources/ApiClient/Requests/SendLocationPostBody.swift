import Foundation
import SharedModels

public struct SendLocationPostBody: Encodable, Sendable {
  public init(
    device: String,
    location: Location? = nil
  ) {
    self.device = device
    self.location = location
  }

  public let device: String
  public let location: Location?

  enum CodingKeys: CodingKey {
    case device
    case latitude
    case longitude
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(device, forKey: .device)
    if let location {
      try container.encodeIfPresent(
        location.coordinate.latitude * 1000000,
        forKey: .latitude
      )
      try container.encodeIfPresent(
        location.coordinate.longitude * 1000000,
        forKey: .longitude
      )
    }
  }
}
