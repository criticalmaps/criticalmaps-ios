//
//  CriticalMaps

import Foundation

class TimeTraveler {
    private var date: Date

    init(_ date: Date = .now) {
        self.date = date
    }

    func travelTime(by interval: TravelInterval, _ calendar: Calendar = .current) {
        date = calendar.date(byAdding: interval.dateComponents, to: date)!
    }

    func generateDate() -> Date { date }
}

extension TimeTraveler {
    enum TravelInterval {
        case minutes(Int)
        case hours(Int)
        case days(Int)

        var dateComponents: DateComponents {
            switch self {
            case let .minutes(value):
                return DateComponents(minute: value)
            case let .hours(value):
                return DateComponents(hour: value)
            case let .days(value):
                return DateComponents(day: value)
            }
        }
    }
}
