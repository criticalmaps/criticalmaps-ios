//
//  CriticalMaps

import CoreLocation
import Foundation

enum EventError: Error {
    case invalidDateError
    case rideIsOutOfRangeError
}

class NextRideManager {
    typealias ResultCallback = (Result<Ride, Error>) -> Void
    private enum Constants {
        static let filterDistance: Double = {
            Double(UserDefaults.standard.nextRideRadius * 1000)
        }()
    }

    public var nextRide: Ride?

    private let apiHandler: CMInApiHandling
    private let filterDistance: Double

    init(apiHandler: CMInApiHandling, filterDistance: Double = Constants.filterDistance) {
        self.apiHandler = apiHandler
        self.filterDistance = filterDistance
    }

    func getNextRide(
        around userCoordinate: CLLocationCoordinate2D,
        _ handler: @escaping ResultCallback
    ) {
        let obfuscatedCoordinate = CoordinateObfuscator.obfuscate(userCoordinate)
        apiHandler.getNextRide(around: obfuscatedCoordinate) { requestResult in
            self.filteredRidesHandler(result: requestResult, handler, userCoordinate)
        }
    }

    private func filterRidesInRange(_ rides: [Ride], _ userCoordinate: CLLocationCoordinate2D) -> [Ride] {
        rides.filter {
            $0.coordinate.clLocation.distance(from: userCoordinate.clLocation) < filterDistance
        }
    }

    private func getUpcomingRide(_ rides: [Ride]) -> Ride? {
        rides
            .sorted(by: \.dateTime)
            .first { $0.dateTime > .now }
    }

    private func filteredRidesHandler(
        result: Result<[Ride], NetworkError>,
        _ handler: @escaping ResultCallback,
        _ userCoordinate: CLLocationCoordinate2D
    ) {
        switch result {
        case let .success(rides):
            let rangeFilteredRides = filterRidesInRange(rides, userCoordinate)
            guard !rangeFilteredRides.isEmpty else {
                handler(.failure(EventError.rideIsOutOfRangeError))
                return
            }
            guard let ride = getUpcomingRide(rangeFilteredRides) else {
                handler(.failure(EventError.invalidDateError))
                return
            }
            nextRide = ride
            handler(.success(ride))
        case let .failure(error):
            handler(.failure(error))
        }
    }
}
