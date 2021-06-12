//
//  File.swift
//  
//
//  Created by Malte on 08.06.21.
//

import CoreLocation
import Foundation
import Helpers

public struct Ride: Hashable, Codable {
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
}

public extension Ride {
  var coordinate: CLLocationCoordinate2D? {
    guard let lat = latitude, let lng = longitude else {
      return nil
    }
    return CLLocationCoordinate2D(latitude: lat, longitude: lng)
  }
  
  var titleAndTime: String {
    let titleWithoutDate = title.removedDatePattern()
    return """
        \(titleWithoutDate)
        \(dateTime.humanReadableDate) - \(dateTime.humanReadableTime)
        """
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

import MapKit
public extension Ride {
  func openInMaps(_ options: [String: Any] = [
    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
  ]) {
    guard let coordinate = self.coordinate else {
      debugPrint("Coordinte is nil")
      return
    }
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
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
    
    var title: String {
      rawValue
        .replacingOccurrences(of: "_", with: " ")
        .capitalized
    }
  }
}

extension Ride {
  static let eventRadii: [Int] = [10, 20, 30, 40]
}
