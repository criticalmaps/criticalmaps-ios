//
//  CriticalMaps

import Foundation

struct TimeTraveler {
    private var date: Date

    mutating func travel(by timeInterval: TimeInterval) {
        date = date.addingTimeInterval(timeInterval)
    }

    func generateDate() -> Date { date }
}

extension TimeTraveler {
    init(_ date: Date = .now) {
        self.init(date: date)
    }
}
