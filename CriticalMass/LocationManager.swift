//
//  LocationManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import CoreLocation

public enum GeolocationRequestError: Error {
    case denied
    case error
}

public enum GeolocationAuthResult {
    /// user have permission on geolocation
    case success
    /// user haven't permission on geolocation
    case denied
    /// user doesn't give permission on his geolocation
    case failure
    /// system dialog reqeusts user permission at this moment
    case requesting
}

public typealias GeolocationCompletion = (Result<CLLocation, GeolocationRequestError>) -> Void
public typealias GeolocationAuthCompletion = (GeolocationAuthResult) -> Void

class LocationManager: NSObject, LocationProvider {
    static var isAuthorized: Bool {
        accessPermission == .authorized
    }

    static var accessPermission: LocationProviderPermission {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways,
             .authorizedWhenInUse:
            return .authorized
        case .notDetermined:
            return .notDetermined
        case .restricted,
             .denied:
            return .denied
        @unknown default:
            assertionFailure()
            return .denied
        }
    }

    private var updateLocationCompletion: ResultCallback<CLLocation>?
    private var locationRequests: [GeolocationCompletion] = []
    private var authRequests: [GeolocationAuthCompletion] = []

    private(set) var currentLocation: CLLocation?

    private let locationManager: CLLocationManager

    init(
        manager: CLLocationManager = CLLocationManager(),
        locationProperties: LocationProperties = LocationProperties()
    ) {
        locationManager = manager
        super.init()
        configureLocationManager(with: locationProperties)
        startTrackingLocation()
    }

    // MARK: - Public API

    public func getCurrentLocation(_ completion: @escaping GeolocationCompletion) {
        if LocationManager.isAuthorized {
            locationRequests.append(completion)
            locationManager.requestLocation()
        } else {
            completion(.failure(.denied))
        }
    }

    public func requestAuthorization(_ completion: @escaping GeolocationAuthCompletion) {
        let status = LocationManager.accessPermission
        switch status {
        case .authorized:
            completion(.success)
        case .denied:
            completion(.denied)
        default:
            completion(.requesting)
            authRequests.append(completion)
            locationManager.requestAlwaysAuthorization()
        }
    }

    // MARK: - Private API

    private func configureLocationManager(with properties: LocationProperties) {
        locationManager.requestAlwaysAuthorization()
        locationManager.activityType = properties.activityType
        locationManager.desiredAccuracy = properties.accuracy
        locationManager.activityType = properties.activityType
        locationManager.delegate = self
    }

    private func startTrackingLocation(allowsBackgroundLocation: Bool = true) {
        locationManager.allowsBackgroundLocationUpdates = allowsBackgroundLocation
        locationManager.startUpdatingLocation()
    }

    private func notifySubscribersAboutError() {
        locationRequests.forEach { $0(.failure(.error)) }
        locationRequests.removeAll()
    }
}

// MARK: CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        updateLocationCompletion?(.failure(.fetchFailed(error)))
        updateLocationCompletion = nil
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            notifySubscribersAboutError()
            return
        }
        locationRequests.forEach { $0(.success(location)) }
        locationRequests.removeAll()

//        locationManager.stopUpdatingLocation()
//        updateLocationCompletion = nil
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization _: CLAuthorizationStatus) {
        guard LocationManager.accessPermission != .notDetermined else {
            return
        }
        let authStatus: GeolocationAuthResult = LocationManager.isAuthorized ? .success : .failure
        authRequests.forEach { $0(authStatus) }
        authRequests.removeAll()
//        NotificationCenter.default.post(name: Notification.observationModeChanged, object: type(of: self).accessPermission)
    }
}

struct LocationProperties {
    /**
     #### GPS, Wifi, And Cell Tower Triangulation Thresholds

     - iOS will usually attempt to exceed the requested accuracy, and may exceed it by a wide margin. For
     example if clear GPS line of sight is available, peak accuracy of 5 metres will be achieved even when only
     requesting 50 metres or even 100 metres. However the higher the desired accuracy, the less effort
     iOS will put into achieving peak possible accuracy.

     - Under some conditions, setting a value of 65 metres or above may allow the device to use wifi triangulation
     alone, without engaging GPS, thus reducing energy consumption. Wifi triangulation is typically more energy
     efficient than GPS.
     */
    let distanceFilterAccuracy: Double = 30.0
    let accuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    let activityType: CLActivityType = .otherNavigation
}
