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
    case rideDisabled
}

final class NextRideManager {
    typealias ResultCallback = (Result<Ride, Error>) -> Void

    public var nextRide: Ride?

    private let apiHandler: CMInApiHandling
    private let eventSettingsStore: RideEventSettingsStore
    private let now: () -> Date

    init(
        apiHandler: CMInApiHandling,
        eventSettingsStore: RideEventSettingsStore,
        now: @escaping () -> Date = Date.init
    ) {
        self.apiHandler = apiHandler
        self.eventSettingsStore = eventSettingsStore
        self.now = now
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
        apiHandler.getNextRide(
            around: obfuscatedCoordinate,
            eventSearchRadius: eventSettingsStore.rideEventSettings.radiusSettings.radius
        ) { requestResult in
            self.filteredRidesHandler(result: requestResult, handler, userCoordinate)
        }
    }

    private func getUpcomingRide(_ rides: [Ride]) -> Ride? {
        rides
            .lazy
            .sorted(by: \.dateTime)
            .first { $0.dateTime > now() }
    }

    private func filteredRidesHandler(
        result: Result<[Ride], NetworkError>,
        _ handler: @escaping ResultCallback,
        _: CLLocationCoordinate2D
    ) {
        switch result {
        case let .success(rides):
            guard !rides.isEmpty else {
                handler(.failure(EventError.rideIsOutOfRangeError))
                return
            }
            if rides.compactMap(\.rideType).isEmpty {
                // None of the rides have a rideType and so the filtering is skipped
                guard let ride = getUpcomingRide(rides) else {
                    handler(.failure(EventError.invalidDateError))
                    return
                }
                // check if ride is cancelled
                guard ride.enabled else {
                    handler(.failure(EventError.rideDisabled))
                    return
                }

                nextRide = ride
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
            // check if ride is cancelled
            guard ride.enabled else {
                handler(.failure(EventError.rideDisabled))
                return
            }

            nextRide = ride
            handler(.success(ride))
        case let .failure(error):
            handler(.failure(error))
        }
    }
}
