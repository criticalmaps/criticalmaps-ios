//
//  CriticalMassInApiHandler.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 12.01.20.
//  Copyright © 2020 Pokus Labs. All rights reserved.
//

import CoreLocation
import Foundation

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}

protocol CMInApiHandling {
    func getNextRide(
        around coordinate: CLLocationCoordinate2D,
        _ handler: @escaping ResultCallback<Ride?>
    )
}

struct CMInApiHandler: CMInApiHandling {
    private let networkLayer: NetworkLayer

    init(networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }

    func getNextRide(
        around coordinate: CLLocationCoordinate2D,
        _ handler: @escaping ResultCallback<Ride?>
    ) {
        let request = NextRideRequest(coordinate: coordinate)
        networkLayer.get(request: request) { requestResult in
            self.sortedRidesHandler(result: requestResult, handler)
        }
    }

    private func sortedRidesHandler(
        result: Result<[Ride], NetworkError>,
        _ handler: @escaping ResultCallback<Ride?>
    ) {
        switch result {
        case let .success(rides):
            let sortedRides = rides.sorted(by: \.dateTime)
            let ride = sortedRides.first {
                $0.dateTime > Date()
            }
            handler(Result.success(ride))
        case let .failure(error):
            handler(Result.failure(error))
        }
    }
}
