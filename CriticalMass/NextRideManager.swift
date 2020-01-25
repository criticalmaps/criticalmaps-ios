//
//  CriticalMaps

import CoreLocation
import Foundation

struct NextRideManager {
    private let apiHandler: CMInApiHandling
    private let filterDistance: Double

    init(apiHandler: CMInApiHandling, filterDistance: Double = 40000) {
        self.apiHandler = apiHandler
        self.filterDistance = filterDistance
    }

    func getNextRide(
        around coordinate: CLLocationCoordinate2D,
        _ handler: @escaping ResultCallback<Ride?>
    ) {
        let obfuscatedCoordinate = CoordinateObfuscator.obfuscate(coordinate)
        apiHandler.getNextRide(around: obfuscatedCoordinate) { requestResult in
            self.filteredRidesHandler(result: requestResult, handler, coordinate)
        }
    }

    private func isNextRideTooFar(_ ride: Ride, _ coordinate: CLLocationCoordinate2D) -> Bool {
        ride.coordinate.clLocation.distance(from: coordinate.clLocation) < filterDistance
    }

    private func getUpcomingRide(_ rides: [Ride]) -> Ride? {
        rides.first { $0.dateTime > Date() }
    }

    private func filteredRidesHandler(
        result: Result<[Ride], NetworkError>,
        _ handler: @escaping ResultCallback<Ride?>,
        _ coordinate: CLLocationCoordinate2D
    ) {
        switch result {
        case let .success(rides):
            guard let ride = getUpcomingRide(rides) else {
                Logger.log(.default, log: .map, "Expected ride to be in the future")
                handler(Result.success(nil))
                return
            }
            guard isNextRideTooFar(ride, coordinate) else {
                Logger.log(.default, log: .map, "Next ride is too far away")
                handler(Result.success(nil))
                return
            }
            handler(Result.success(ride))
        case let .failure(error):
            handler(Result.failure(error))
        }
    }
}
