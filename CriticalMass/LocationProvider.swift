//
//  LocationProvider.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/17/19.
//

import Foundation

protocol LocationProvider {
    var currentLocation: Location? { get }
}
