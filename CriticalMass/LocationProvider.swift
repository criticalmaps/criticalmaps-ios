//
//  LocationProvider.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/17/19.
//

import Foundation

enum LocationProviderPermission {
    case authorized
    case denied
    case disabled
    case unkown
}

protocol LocationProvider {
    var currentLocation: Location? { get }
    static var accessPermission: LocationProviderPermission { get }
}
