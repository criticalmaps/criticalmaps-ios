import ComposableArchitecture
import Helpers
import SharedModels
import Foundation
import Testing

struct RideTimeTests {
  @Test("Ride in new york timezone")
  func rideWithNewYorkTimezone() {
    withDependencies {
      $0.locale = Locale(identifier: "en_US")
    } operation: {
      let ride = Ride.mock(timeZone: .newYork, timestamp: 1727478000)
      let rideTime = ride.rideTime
      #expect(rideTime == "7:00 PM")
    }
  }
  
  @Test("Ride in berlin timezone")
  func rideWithBerlinTimezone() {
    withDependencies {
      $0.locale = Locale(identifier: "de_DE")
    } operation: {
      let ride = Ride.mock(timeZone: .germany, timestamp: 1725192000)
      let rideTime = ride.rideTime
      #expect(rideTime == "14:00")
    }
  }
  
  @Test("Ride in GMT timezone")
  func rideWithGMTTimezone() {
    withDependencies {
      $0.locale = Locale(identifier: "pt_PT")
    } operation: {
      let ride = Ride.mock(timeZone: .gmt, timestamp: 1727452800)
      let rideTime = ride.rideTime
      #expect(rideTime == "16:00")
    }
  }
}

private extension Ride {
  static func mock(timeZone: TimeZone, timestamp: TimeInterval) -> Self {
    Self(
      id: 0,
      city: Ride.City(id: 1, name: "Berlin", timezone: timeZone.identifier),
      slug: nil,
      title: "CriticalMaps Berlin",
      description: nil,
      dateTime: Date(timeIntervalSince1970: timestamp),
      location: nil,
      latitude: 53.1235,
      longitude: 13.4234,
      estimatedParticipants: nil,
      estimatedDistance: nil,
      estimatedDuration: nil,
      enabled: true,
      disabledReason: nil,
      disabledReasonMessage: nil,
      rideType: .criticalMass
    )
  }
}
