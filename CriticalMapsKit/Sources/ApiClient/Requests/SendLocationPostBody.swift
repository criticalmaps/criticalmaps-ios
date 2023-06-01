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
    try container.encodeIfPresent(self.location?.coordinate.latitude, forKey: .latitude)
    try container.encodeIfPresent(self.location?.coordinate.longitude, forKey: .longitude)
  }
}
