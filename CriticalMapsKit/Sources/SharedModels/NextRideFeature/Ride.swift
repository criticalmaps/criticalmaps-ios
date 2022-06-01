import CoreLocation
import Foundation
import Helpers
import MapKit

public struct Ride: Hashable, Codable, Identifiable {
  public let id: Int
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
  var coordinate: Coordinate? {
    guard let lat = latitude, let lng = longitude else {
      return nil
    }
    return Coordinate(latitude: lat, longitude: lng)
  }

  var titleAndTime: String {
    let titleWithoutDate = title.removedDatePattern()
    return """
    \(titleWithoutDate)
    \(rideDateAndTime)
    """
  }

  var rideDateAndTime: String {
    "\(dateTime.humanReadableDate) - \(dateTime.humanReadableTime)"
  }

  var shareMessage: String {
    guard let location = location else {
      return titleAndTime
    }
    return """
    \(titleAndTime)
    \(location)
    """
  }
}

public extension Ride {
  func openInMaps(_ options: [String: Any] = [
    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
  ]) {
    guard let coordinate = coordinate else {
      debugPrint("Coordinte is nil")
      return
    }
    let placemark = MKPlacemark(coordinate: coordinate.asCLLocationCoordinate, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = location
    mapItem.openInMaps(launchOptions: options)
  }
}

public extension Ride {
  enum RideType: String, CaseIterable, Codable {
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
