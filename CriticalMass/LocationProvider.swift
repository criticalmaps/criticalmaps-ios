//
//  LocationProvider.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/17/19.
//

import Foundation

public enum LocationProviderPermission {
    case authorized
    case denied
    case disabled
    case unkown
}

public protocol LocationProvider {
    var currentLocation: Location? { get }
    static var accessPermission: LocationProviderPermission { get }

    func updateLocation()
    var locationUpdateHandler: (() -> Void)? { get set }
    var locationErrorHandler: (() -> Void)? { get set }
}
