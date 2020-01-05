//
//  LocationManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import CoreLocation
import CriticalMapsFoundation
import CriticalMapsKit

class LocationManager: NSObject, CLLocationManagerDelegate, LocationProvider {
    static var accessPermission: LocationProviderPermission {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways,
             .authorizedWhenInUse:
            return .authorized
        case .notDetermined:
            return .unkown
        case .restricted,
             .denied:
            return .denied
        @unknown default:
            assertionFailure()
            return .denied
        }
    }

    private var updateLocationCompletion: ResultCallback<Location>?

    func updateLocation(completion: ResultCallback<Location>?) {
        updateLocationCompletion = completion
        locationManager.requestLocation()
    }

    private var didSetInitialLocation = false

    private var _currentLocation: Location?
    private(set)
    var currentLocation: Location? {
        set {
            _currentLocation = newValue
            guard didSetInitialLocation == false else {
                return
            }
            if let location = currentLocation {
                didSetInitialLocation = true
                NotificationCenter.default.post(name: Notification.initialGpsDataReceived, object: location)
            }
        }
        get {
            guard type(of: self).accessPermission == .authorized, !ObservationModePreferenceStore().isEnabled else {
                return nil
            }
            return _currentLocation
        }
    }

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        configureLocationManager()
    }

    func configureLocationManager() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.activityType = .otherNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        updateLocationCompletion?(.failure(.fetchFailed(error)))
        updateLocationCompletion = nil
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let location = Location(lastLocation)

            currentLocation = location
            updateLocationCompletion?(.success(location))
        } else {
            updateLocationCompletion?(.failure(.noData(nil)))
        }

        locationManager.stopUpdatingLocation()
        updateLocationCompletion = nil
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization _: CLAuthorizationStatus) {
        NotificationCenter.default.post(name: Notification.observationModeChanged, object: type(of: self).accessPermission)
    }
}
