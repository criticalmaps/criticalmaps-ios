//
//  LocationManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import CoreLocation
import Foundation

extension Location {
    init(_ clLocation: CLLocation, name: String? = nil, color: String? = nil) {
        longitude = Float(clLocation.coordinate.longitude)
        latitude = Float(clLocation.coordinate.latitude)
        timestamp = Float(clLocation.timestamp.timeIntervalSince1970)
        self.name = name
        self.color = color
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate, LocationProvider {
    private(set)
    var currentLocation: Location?

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        configure()
    }

    func configure() {
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.activityType = .otherNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func requestLocation() {
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(_: CLLocationManager, didFailWithError _: Error) {
        if #available(iOS 9.0, *) {
            // we don't need to call stopUpdatingLocation as we are using requestLocation() on iOS 9 and later
        } else {
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = Location(location)
        }
        if #available(iOS 9.0, *) {
            // we don't need to call stopUpdatingLocation as we are using requestLocation() on iOS 9 and later
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
}
