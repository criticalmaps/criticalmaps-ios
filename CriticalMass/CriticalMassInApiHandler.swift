//
//  CriticalMassInApiHandler.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 12.01.20.
//  Copyright © 2020 Pokus Labs. All rights reserved.
//

import CoreLocation
import Foundation

protocol CMInApiHandling {
    func getNextRide(around coordinate: CLLocationCoordinate2D, _ handler: @escaping ResultCallback<[Ride]>)
}

struct CMInApiHandler: CMInApiHandling {
    private let networkLayer: NetworkLayer

    init(networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }

    func getNextRide(around coordinate: CLLocationCoordinate2D, _ handler: @escaping ResultCallback<[Ride]>) {
        let request = NextRideRequest(coordinate: coordinate)
        networkLayer.get(request: request, completion: handler)
    }
}
