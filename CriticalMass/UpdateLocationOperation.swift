//
//  UpdateLocationOperation.swift
//  CriticalMaps
//
//  Created by Илья Глущук on 07/11/2019.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

final class UpdateLocationOperation: AsyncOperation {
    private var locationProvider: LocationProvider

    init(locationProvider: LocationProvider) {
        self.locationProvider = locationProvider
        super.init()
    }

    override func main() {
        guard type(of: locationProvider).accessPermission == .authorized else {
            state = .finished
            return
        }

        locationProvider.locationUpdateHandler = { [weak self] in
            self?.state = .finished
        }

        locationProvider.locationErrorHandler = { [weak self] in
            self?.state = .finished
        }

        locationProvider.updateLocation()
    }
}
