import Foundation
import SharedModels

public struct SendLocationPostBody: Encodable {
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
    try container.encode(self.device, forKey: .device)
    if let location {
      try container.encodeIfPresent(
        location.coordinate.latitude * 1_000_000,
        forKey: .latitude
      )
      try container.encodeIfPresent(
        location.coordinate.longitude * 1_000_000,
        forKey: .longitude
      )
    }
  }
}
