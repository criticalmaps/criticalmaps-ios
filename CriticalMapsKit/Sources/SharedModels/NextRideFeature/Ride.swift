import ComposableArchitecture
import CoreLocation
import Foundation
import Helpers
import MapKit

public struct Ride: Hashable, Codable, Identifiable, Sendable {
  public let id: Int
  public var city: City?
  public let slug: String?
  public let title: String
  public let description: String?
  public let dateTime: Date
  public let location: String?
  public let latitude: Double?
  public let longitude: Double?
  public let estimatedParticipants: Int?
  public let estimatedDistance: Double?
  public let estimatedDuration: Double?
  public let enabled: Bool
  public let disabledReason: String?
  public let disabledReasonMessage: String?
  public let rideType: RideType?

  public init(
    id: Int,
    city: City? = nil,
    slug: String? = nil,
    title: String,
    description: String? = nil,
    dateTime: Date,
    location: String? = nil,
    latitude: Double? = nil,
    longitude: Double? = nil,
    estimatedParticipants: Int? = nil,
    estimatedDistance: Double? = nil,
    estimatedDuration: Double? = nil,
    enabled: Bool,
    disabledReason: String? = nil,
    disabledReasonMessage: String? = nil,
    rideType: Ride.RideType? = nil
  ) {
    self.id = id
    self.city = city
    self.slug = slug
    self.title = title
    self.description = description
    self.dateTime = dateTime
    self.location = location
    self.latitude = latitude
    self.longitude = longitude
    self.estimatedParticipants = estimatedParticipants
    self.estimatedDistance = estimatedDistance
    self.estimatedDuration = estimatedDuration
    self.enabled = enabled
    self.disabledReason = disabledReason
    self.disabledReasonMessage = disabledReasonMessage
    self.rideType = rideType
  }
}

public extension Ride {
  struct City: Codable, Hashable, Sendable {
    let id: Int
    let name: String
    let timezone: String

    public init(
      id: Int,
      name: String,
      timezone: String
    ) {
      self.id = id
      self.name = name
      self.timezone = timezone
    }
  }
}

public extension Ride {
  var coordinate: Coordinate? {
    guard let lat = latitude, let lng = longitude else {
      return nil
    }
    return Coordinate(latitude: lat, longitude: lng)
  }

  var titleWithoutDatePattern: String {
    title.removedDatePattern()
  }

  var titleAndTime: String {
    """
    \(titleWithoutDatePattern)
    \(rideDateAndTime)
    """
  }

  var rideDateAndTime: String {
    "\(dateTime.humanReadableDate) - \(rideTime)"
  }

  var rideTime: String {
    if
      let cityTimeZone = city?.timezone,
      let timeZone = TimeZone(identifier: cityTimeZone)
    {
      dateTime.formatted(Date.FormatStyle.shortTimeWithEventTimeZone(timeZone))
    } else {
      dateTime.formatted(Date.FormatStyle.localeAwareShortTime)
    }
  }

  var shareMessage: String {
    guard let location else {
      return titleAndTime
    }
    return """
    \(titleAndTime)
    \(location)
    
    \(description ?? "")
    """
  }
}

public extension Ride {
  func openInMaps(_ options: [String: Any] = [
    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
  ]) {
    guard let coordinate else {
      return
    }
    let placemark = MKPlacemark(coordinate: coordinate.asCLLocationCoordinate, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = location
    mapItem.openInMaps(launchOptions: options)
  }
}

public extension Ride {
  enum RideType: String, CaseIterable, Codable, Sendable {
    case criticalMass = "CRITICAL_MASS"
    case kidicalMass = "KIDICAL_MASS"
    case nightride = "NIGHT_RIDE"
    case lunchride = "LUNCH_RIDE"
    case dawnride = "DAWN_RIDE"
    case duskride = "DUSK_RIDE"
    case demonstration = "DEMONSTRATION"
    case alleycat = "ALLEYCAT"
    case tour = "TOUR"
    case event = "EVENT"

    public var title: String {
      rawValue
        .replacingOccurrences(of: "_", with: " ")
        .capitalized
    }
  }
}

private extension Date.FormatStyle {
  static func shortTimeWithEventTimeZone(_ timezone: TimeZone) -> Self {
    @Dependency(\.locale) var locale

    return Self(
      date: .omitted,
      time: .shortened,
      locale: locale,
      timeZone: timezone
    )
  }
}
