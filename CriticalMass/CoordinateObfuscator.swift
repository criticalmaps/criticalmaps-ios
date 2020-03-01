//
//  CriticalMaps

import CoreLocation

struct CoordinateObfuscator {
    enum ObfuscationPrecisionType {
        case firstDecimal // is worth up to 11.1 km
        case secondDecimal // is worth up to 1.1 km
        case thirdDecimal // is worth up to 110 m
        case fourthDecimal // is worth up to 11 m
        case custom(ClosedRange<Double>)

        var range: ClosedRange<Double> {
            switch self {
            case .firstDecimal, .secondDecimal, .thirdDecimal, .fourthDecimal:
                let lowerBound: Double = -9
                let upperBound: Double = 9
                return (lowerBound / decimalFactor ... upperBound / decimalFactor)
            case let .custom(customRange): return customRange
            }
        }

        var randomInRange: Double {
            Double.random(in: range)
        }

        private var decimalFactor: Double {
            switch self {
            case .firstDecimal: return 10
            case .secondDecimal: return 100
            case .thirdDecimal: return 1000
            case .fourthDecimal: return 10000
            case .custom: return 1
            }
        }
    }

    static func obfuscate(
        _ coordinate: CLLocationCoordinate2D,
        precisionType: ObfuscationPrecisionType = .thirdDecimal
    ) -> CLLocationCoordinate2D {
        let seededLat = coordinate.latitude + precisionType.randomInRange
        let seededLon = coordinate.longitude + precisionType.randomInRange
        return CLLocationCoordinate2D(latitude: seededLat, longitude: seededLon)
    }
}
