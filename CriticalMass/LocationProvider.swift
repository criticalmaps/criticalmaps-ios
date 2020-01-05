//
//  LocationProvider.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/17/19.
//

import CriticalMapsFoundation
import Foundation

public enum LocationProviderPermission: String {
    case authorized
    case denied
    case disabled
    case unkown
}

public protocol LocationProvider {
    var currentLocation: Location? { get }
    static var accessPermission: LocationProviderPermission { get }

    func updateLocation(completion: ResultCallback<Location>?)
}
