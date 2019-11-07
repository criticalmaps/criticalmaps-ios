//
//  LocationRequestOperation.swift
//  CriticalMaps
//
//  Created by Илья Глущук on 07/11/2019.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import CoreLocation

final class LocationRequestOperation: Operation {
    private weak var locationManager: CLLocationManager?

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
    }

    override func main() {
        guard LocationManager.accessPermission == .authorized else { return }
        locationManager?.requestLocation()
    }
}
