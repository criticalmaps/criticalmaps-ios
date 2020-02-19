//
//  LocationProvider.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/17/19.
//

import CoreLocation
import Foundation

public enum LocationProviderPermission: String {
    case authorized
    case denied
    case disabled
    case notDetermined
}

public protocol LocationProvider {
    var currentLocation: CLLocation? { get }

    func getCurrentLocation(_ completion: @escaping GeolocationCompletion)
    func requestAuthorization(_ completion: @escaping GeolocationAuthCompletion)
}
