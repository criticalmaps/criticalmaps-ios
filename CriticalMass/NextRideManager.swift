//
//  CriticalMaps

import CoreLocation
import Foundation

enum EventError: Error {
    case eventsAreNotEnabled
    case invalidDateError
    case rideIsOutOfRangeError
    case noUpcomingRides
    case rideTypeIsFiltered
}

final class NextRideManager {
    typealias ResultCallback = (Result<Ride, Error>) -> Void

    public var nextRide: Ride?

    private let apiHandler: CMInApiHandling
    private let eventSettingsStore: RideEventSettingsStore

    init(
        apiHandler: CMInApiHandling,
        eventSettingsStore: RideEventSettingsStore
    ) {
        self.apiHandler = apiHandler
        self.eventSettingsStore = eventSettingsStore
    }

    func getNextRide(
        around userCoordinate: CLLocationCoordinate2D,
        _ handler: @escaping ResultCallback
    ) {
        guard eventSettingsStore.rideEventSettings.isEnabled else {
            handler(.failure(EventError.eventsAreNotEnabled))
            return
        }
        let obfuscatedCoordinate = CoordinateObfuscator.obfuscate(userCoordinate)
        apiHandler.getNextRide(around: obfuscatedCoordinate) { requestResult in
            self.filteredRidesHandler(result: requestResult, handler, userCoordinate)
        }
    }

    private func getUpcomingRide(_ rides: [Ride]) -> Ride? {
        rides
            .lazy
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
            guard !rides.isEmpty else {
                handler(.failure(EventError.rideIsOutOfRangeError))
                return
            }
            if rides.compactMap(\.rideType).isEmpty {
                // All rides do not have a rideType and so the filtering is skipped
                guard let ride = getUpcomingRide(rides) else {
                    handler(.failure(EventError.invalidDateError))
                    return
                }
                handler(.success(ride))
                return
            }
            let eventTypeFilteredRides = rides.filter {
                guard let type = $0.rideType else { return true }
                return !eventSettingsStore.rideEventSettings.filteredEvents.contains(type)
            }
            guard !eventTypeFilteredRides.isEmpty else {
                handler(.failure(EventError.rideTypeIsFiltered))
                return
            }
            guard let ride = getUpcomingRide(eventTypeFilteredRides) else {
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
