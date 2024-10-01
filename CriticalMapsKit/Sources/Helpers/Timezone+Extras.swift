import Foundation

public extension TimeZone {
  // Europe
  static let germany = TimeZone(identifier: "Europe/Berlin")!
  static let gmt = TimeZone(identifier: "GMT")!
  static let spain = TimeZone(identifier: "Europe/Madrid")!
  static let france = TimeZone(identifier: "Europe/Paris")!
  static let greece = TimeZone(identifier: "Europe/Athens")!
  static let london = TimeZone(identifier: "Europe/London")!
  
  // America
  static let ecuador = TimeZone(identifier: "America/Guayaquil")!
  static let cuba = TimeZone(identifier: "America/Havana")!
  
  // Africa
  static let egypt = TimeZone(identifier: "Africa/Cairo")!
  static let southAfrica = TimeZone(identifier: "Africa/Johannesburg")!
  
  // Asia
  static let india = TimeZone(identifier: "Asia/Kolkata")!
  static let japan = TimeZone(identifier: "Asia/Tokyo")!
  
  // USA
  static let newYork = TimeZone(identifier: "America/New_York")!
  static let losAngeles = TimeZone(identifier: "America/Los_Angeles")!
}
