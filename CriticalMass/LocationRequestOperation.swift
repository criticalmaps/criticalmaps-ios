//
//  LocationRequestOperation.swift
//  CriticalMaps
//
//  Created by Илья Глущук on 07/11/2019.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import CoreLocation

final class LocationRequestOperation: AsyncOperation {
    private weak var locationManager: LocationManager?

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        super.init()
    }

    override func main() {
        guard LocationManager.accessPermission == .authorized else {
            state = .finished
            return
        }

        locationManager?.locationUpdateHandler = { [weak self] in
            self?.state = .finished
        }

        locationManager?.locationErrorHandler = { [weak self] in
            self?.state = .finished
        }

        locationManager?.requestLocation()
    }
}
