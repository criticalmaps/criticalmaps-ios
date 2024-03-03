import ComposableArchitecture
import Helpers
import SharedModels
import XCTest

final class RideTests: XCTestCase {
  func test_rideInGMTTimezone() {
    // arrange
    let ride = Ride.mock()
    
    // act
    withDependencies {
      $0.timeZone = .gmt
    } operation: {
      XCTAssertEqual(
        "20:00",
        ride.dateTime.humanReadableTime
      )
    }
  }
  
  func test_rideInGermanTimezone() {
    // arrange
    let ride = Ride.mock()
    
    // act
    withDependencies {
      $0.timeZone = .germany
    } operation: {
      XCTAssertEqual(
        "20:00",
        ride.dateTime.humanReadableTime
      )
    }
  }
  
  func test_rideInGreeceTimezone() {
    // arrange
    let ride = Ride.mock()
    
    // act
    withDependencies {
      $0.timeZone = .greece
      $0.calendar = .init(identifier: .gregorian)
    } operation: {
      XCTAssertEqual(
        "20:00",
        ride.dateTime.humanReadableTime
      )
    }
  }
  
  func test_rideInEcuadorTimezone() {
    // arrange
    let ride = Ride.mock()
    
    // act
    withDependencies {
      $0.timeZone = .ecuador
      $0.calendar = .init(identifier: .gregorian)
    } operation: {
      XCTAssertEqual(
        "20:00",
        ride.dateTime.humanReadableTime
      )
    }
  }
}

extension Ride {
  static func mock() -> Self {
    Self(
      id: 0,
      slug: nil,
      title: "CriticalMaps Berlin",
      description: nil,
      dateTime: Date(timeIntervalSince1970: 1711738800),
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
