//
//  RequestManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

class RequestManager {
    private let kRequestRepeatTime: TimeInterval = 12.0
    private let kBaseURL = URL(string: "https://api.criticalmaps.net/")!

    private var hasActiveRequest = false

    private var dataStore: DataStore
    private var locationProvider: LocationProvider
    private var networkLayer: NetworkLayer

    init(dataStore: DataStore, locationProvider: LocationProvider, networkLayer: NetworkLayer) {
        self.dataStore = dataStore
        self.locationProvider = locationProvider
        self.networkLayer = networkLayer
        configureTimer()
    }

    private func configureTimer() {
        Timer.scheduledTimer(timeInterval: kRequestRepeatTime, target: self, selector: #selector(timerDidUpdate(timer:)), userInfo: nil, repeats: true)
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
