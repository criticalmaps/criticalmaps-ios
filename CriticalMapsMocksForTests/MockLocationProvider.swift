//
// Created for CriticalMaps in 2020

@testable import CriticalMaps

class MockLocationProvider: LocationProvider {
    func updateLocation(completion: ResultCallback<Location>?) {
        if let location = mockLocation {
            completion?(.success(location))
        } else {
            completion?(.failure(.noData(nil)))
        }
    }

    static var accessPermission: LocationProviderPermission = .authorized

    var mockLocation: Location?

    var currentLocation: Location? {
        mockLocation
    }
}
