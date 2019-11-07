//
//  LocationManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import CoreLocation

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

    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        return queue
    }()

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

    init(updateInterval: TimeInterval = 11) {
        super.init()
        configureLocationManager()
        setupLocationUpdate(with: updateInterval)
    }

    func configureLocationManager() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.activityType = .otherNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    private func setupLocationUpdate(with interval: TimeInterval) {
        let operation = LocationRequestOperation(locationManager: locationManager)
        operation.completionBlock = { [weak self] in
            guard let self = self else { return }

            let waitOperation = self.makeWaitOperation(with: interval)
            self.operationQueue.addOperation(waitOperation)
        }

        operationQueue.addOperation(operation)
    }

    private func makeWaitOperation(with interval: TimeInterval) -> Operation {
        let operation = WaitOperation(with: interval)
        operation.completionBlock = { [weak self] in
            self?.setupLocationUpdate(with: interval)
        }

        return operation
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(_: CLLocationManager, didFailWithError _: Error) {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = Location(location)
        }
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization _: CLAuthorizationStatus) {
        NotificationCenter.default.post(name: Notification.observationModeChanged, object: type(of: self).accessPermission)
    }
}
