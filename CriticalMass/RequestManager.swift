//
//  RequestManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

class RequestManager {
    private struct PostBody: Codable {
        var device: String
        var location: Location
    }

    private let kBaseURL = URL(string: "https://api.criticalmaps.net/")!

    private var hasActiveRequest = false

    private var dataStore: DataStore
    private var locationProvider: LocationProvider
    private var networkLayer: NetworkLayer
    private var deviceId: String

    init(dataStore: DataStore, locationProvider: LocationProvider, networkLayer: NetworkLayer, interval: TimeInterval = 12.0, deviceId: String) {
        self.deviceId = deviceId
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
        let completion: (ApiResponse?) -> Void = { response in
            self.hasActiveRequest = false
            if let response = response {
                self.dataStore.update(with: response)
            }
        }

        // We only use a post request if we have a location to post
        if let currentLocation = locationProvider.currentLocation {
            let body = PostBody(device: deviceId, location: currentLocation)
            guard let bodyData = try? JSONEncoder().encode(body) else {
                completion(nil)
                return
            }
            networkLayer.post(with: kBaseURL, decodable: ApiResponse.self, bodyData: bodyData, completion: completion)
        } else {
            networkLayer.get(with: kBaseURL, decodable: ApiResponse.self, completion: completion)
        }
    }
}
