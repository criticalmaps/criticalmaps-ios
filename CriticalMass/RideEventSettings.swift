//
// Created for CriticalMaps in 2020

import Foundation

protocol RideEventSettingsStore {
    var rideEventSettings: RideEventSettings { get set }
}

struct RideEventSettings: Codable, Toggleable {
    var isEnabled: Bool
    var typeSettings: [RideEventTypeSetting]
    var radiusSettings: RideEventRadius

    var filteredEvents: [Ride.RideType] {
        typeSettings
            .filter { !$0.isEnabled }
            .map(\.type)
    }
}

extension RideEventSettings {
    struct RideEventRadius: Codable, Toggleable {
        var radius: Int
        var isEnabled: Bool
    }

    struct RideEventTypeSetting: Codable, Toggleable {
        let type: Ride.RideType
        var isEnabled: Bool
    }
}

extension Array where Element == RideEventSettings.RideEventTypeSetting {
    static let all = Ride.RideType.allCases.map { RideEventSettings.RideEventTypeSetting(type: $0, isEnabled: true) }
}
