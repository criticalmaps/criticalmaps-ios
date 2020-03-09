//
//  CriticalMaps

import Foundation

class TimeTraveler {
    private var date: Date

    init(_ date: Date = .now) {
        self.date = date
    }

    @discardableResult
    func travelTime(by interval: TravelInterval, _ calendar: Calendar = .current) -> Self {
        date = calendar.date(byAdding: interval.dateComponents, to: date)!
        return self
    }

    func generateDate() -> Date { date }
}

extension TimeTraveler {
    enum TravelInterval {
        case seconds(Int)
        case minutes(Int)
        case hours(Int)
        case days(Int)
        case months(Int)

        var dateComponents: DateComponents {
            switch self {
            case let .seconds(value):
                return DateComponents(second: value)
            case let .minutes(value):
                return DateComponents(minute: value)
            case let .hours(value):
                return DateComponents(hour: value)
            case let .days(value):
                return DateComponents(day: value)
            case let .months(value):
                return DateComponents(month: value)
            }
        }
    }
}
