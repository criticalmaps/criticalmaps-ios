//
// Created for CriticalMaps in 2020

import Foundation

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

struct RideEventTypeSetting: Codable, Toggleable {
    let type: RideType
    var isEnabled: Bool
}

extension Array where Element == RideEventTypeSetting {
    static let all = RideType.allCases.map { RideEventTypeSetting(type: $0, isEnabled: true) }
}
