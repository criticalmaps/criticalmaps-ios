//
//  CriticalMaps

import Foundation

class RideChecker {
    private let timeTraveler: TimeTraveler
    private lazy var halfAnHourThreshold: TimeInterval = -1800

    init(_ timeTraveler: TimeTraveler = TimeTraveler()) {
        self.timeTraveler = timeTraveler
    }

    func isRideOutdated(_ ride: Ride) -> Bool {
        ride.dateTime.timeIntervalSince(timeTraveler.generateDate()) < halfAnHourThreshold
    }
}
