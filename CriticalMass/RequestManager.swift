//
//  RequestManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

class RequestManager {
    private let kBaseURL = URL(string: "https://api.criticalmaps.net/")!

    private var hasActiveRequest = false

    private var dataStore: DataStore
    private var locationProvider: LocationProvider
    private var networkLayer: NetworkLayer

    init(dataStore: DataStore, locationProvider: LocationProvider, networkLayer: NetworkLayer, interval: TimeInterval = 12.0) {
        self.dataStore = dataStore
        self.locationProvider = locationProvider
        self.networkLayer = networkLayer
        configureTimer(with: interval)
    }

    private func configureTimer(with interval: TimeInterval) {
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerDidUpdate(timer:)), userInfo: nil, repeats: true)
    }

    @objc private func timerDidUpdate(timer _: Timer) {
        updateData()
    }

    private func updateData() {
        guard hasActiveRequest == false else { return }
        hasActiveRequest = true
        networkLayer.get(with: kBaseURL, decodable: ApiResponse.self) { response in
            self.hasActiveRequest = false
            if let response = response {
                self.dataStore.update(with: response)
            }
        }
    }
}
