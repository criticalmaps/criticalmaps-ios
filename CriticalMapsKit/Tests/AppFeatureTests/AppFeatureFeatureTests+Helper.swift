import ComposableArchitecture
import ComposableCoreLocation
import Foundation
import MapFeature
import NextRideFeature
import SharedModels
import UserDefaultsClient

// MARK: Helper

let testError = NSError(domain: "", code: 1, userInfo: [:])

extension Coordinate {
  static func make() -> Self {
    let randomDouble: () -> Double = { Double.random(in: 0.0 ... 80.00) }
    return Coordinate(latitude: randomDouble(), longitude: randomDouble())
  }
}

let testDate: () -> Date = { Date(timeIntervalSinceReferenceDate: 0) }

extension Dictionary where Key == String, Value == SharedModels.Location {
  static func make(_ max: Int = 5) -> [Key: Value] {
    let locations = Array(0 ... max).map { index in
      SharedModels.Location(
        coordinate: .make(),
        timestamp: testDate().timeIntervalSince1970 + Double(index % 2 == 0 ? index : -index)
      )
    }
    var locationDict: [String: SharedModels.Location] = [:]
    for index in locations.indices {
      locationDict[String(index)] = locations[index]
    }
    return locationDict
  }
}

extension Array where Element == Rider {
  static func make(_ max: Int = 5) -> [Element] {
    var elements = [Element]()
    for index in 0...max {
      elements.append(
        Rider(
          id: String(describing: index),
          coordinate: .init(
            latitude: Double.random(in: 0..<180),
            longitude: Double.random(in: 0..<180)
          ),
          timestamp: Double.random(in: 0..<180)
        )
      )
    }
    return elements
  }
}

extension Array where Element == ChatMessage {
  static func make(_ max: Int = 5) -> [Element] {
    var elements = [Element]()
    for index in 0...max {
      let message = ChatMessage(
        identifier: "ID",
        device: "DEVICE",
        message: "Hello World!",
        timestamp: testDate().timeIntervalSince1970 + Double(index % 2 == 0 ? index : -index)
      )
      elements.append(message)
    }
    return elements
  }
}

extension Ride {
  static let mock1 = Ride(
    id: 123,
    slug: nil,
    title: "Next Ride",
    description: nil,
    dateTime: Date(timeIntervalSince1970: 1234340120),
    location: nil,
    latitude: nil,
    longitude: nil,
    estimatedParticipants: 123,
    estimatedDistance: 312,
    estimatedDuration: 3,
    enabled: true,
    disabledReason: nil,
    disabledReasonMessage: nil,
    rideType: .criticalMass
  )
  static let mock2 = Ride(
    id: 3,
    slug: nil,
    title: "Next Ride",
    description: nil,
    dateTime: Date(timeIntervalSince1970: 1234340120),
    location: nil,
    latitude: nil,
    longitude: nil,
    estimatedParticipants: 123,
    estimatedDistance: 312,
    estimatedDuration: 3,
    enabled: true,
    disabledReason: nil,
    disabledReasonMessage: nil,
    rideType: .alleycat
  )
}
