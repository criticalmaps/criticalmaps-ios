//
//  CriticalMaps

import Foundation

class RideChecker {
    private let timeTraveler: TimeTraveler
    private let halfAnHourThreshold: TimeInterval = -1800

    init(_ timeTraveler: TimeTraveler = TimeTraveler()) {
        self.timeTraveler = timeTraveler
    }

    func isRideOutdated(_ ride: Ride) -> Bool {
        ride.dateTime.timeIntervalSince(timeTraveler.generateDate()) < halfAnHourThreshold
    }
}
