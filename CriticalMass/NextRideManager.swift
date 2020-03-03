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
        static let filterDistance: Double = 40000
    }

    public var nextRide: Ride?

    private let apiHandler: CMInApiHandling
    private let filterDistance: Double

    init(apiHandler: CMInApiHandling, filterDistance: Double = Constants.filterDistance) {
        self.apiHandler = apiHandler
        self.filterDistance = filterDistance
    }

    func getNextRide(
        around coordinate: CLLocationCoordinate2D,
        _ handler: @escaping ResultCallback
    ) {
        let obfuscatedCoordinate = CoordinateObfuscator.obfuscate(coordinate)
        apiHandler.getNextRide(around: obfuscatedCoordinate) { requestResult in
            self.filteredRidesHandler(result: requestResult, handler, coordinate)
        }
    }

    private func isRideInRange(_ ride: Ride, _ coordinate: CLLocationCoordinate2D) -> Bool {
        ride.coordinate.clLocation.distance(from: coordinate.clLocation) < filterDistance
    }

    private func getUpcomingRide(_ rides: [Ride]) -> Ride? {
        rides
            .sorted(by: \.dateTime)
            .first { $0.dateTime > .now }
    }

    private func filteredRidesHandler(
        result: Result<[Ride], NetworkError>,
        _ handler: @escaping ResultCallback,
        _ coordinate: CLLocationCoordinate2D
    ) {
        switch result {
        case let .success(rides):
            guard let ride = getUpcomingRide(rides) else {
                handler(.failure(EventError.invalidDateError))
                return
            }
            guard isRideInRange(ride, coordinate) else {
                handler(.failure(EventError.rideIsOutOfRangeError))
                return
            }
            nextRide = ride
            handler(.success(ride))
        case let .failure(error):
            handler(.failure(error))
        }
    }
}
