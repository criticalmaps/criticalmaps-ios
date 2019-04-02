//
//  LocationManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, LocationProvider {
    static var accessPermission: LocationProviderPermission {
        if Preferences.gpsEnabled {
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
        } else {
            return .denied
        }
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
                NotificationCenter.default.post(name: NSNotification.Name("initialGpsDataReceived"), object: location)
            }
        }
        get {
            guard type(of: self).accessPermission == .authorized else {
                return nil
            }
            return _currentLocation
        }
    }

    private let locationManager = CLLocationManager()

    init(updateInterval: TimeInterval = 11) {
        super.init()
        configureLocationManager()
        configureTimer(with: updateInterval)
    }

    func configureLocationManager() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.activityType = .otherNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    private func configureTimer(with interval: TimeInterval) {
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerDidUpdate(timer:)), userInfo: nil, repeats: true)
    }

    @objc private func timerDidUpdate(timer _: Timer) {
        requestLocation()
    }

    func requestLocation() {
        guard type(of: self).accessPermission == .authorized else { return }
        locationManager.requestLocation()
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
        NotificationCenter.default.post(name: NSNotification.Name("gpsStateChanged"), object: type(of: self).accessPermission)
    }
}
