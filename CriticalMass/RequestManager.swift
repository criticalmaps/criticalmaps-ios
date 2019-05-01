//
//  RequestManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

public class RequestManager {
    private struct SendLocationPostBody: Codable {
        var device: String
        var location: Location
    }

    private struct SendMessagePostBody: Codable {
        var device: String
        var messages: [SendChatMessage]
    }

    private let endpoint = URL(string: "https://api.criticalmaps.net/")!

    private var hasActiveRequest = false

    private var dataStore: DataStore
    private var locationProvider: LocationProvider
    private var networkLayer: NetworkLayer
    private var deviceId: String

    init(dataStore: DataStore, locationProvider: LocationProvider, networkLayer: NetworkLayer, interval: TimeInterval = 12.0, deviceId: String, url _: URL) {
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

    private func defaultCompletion(for response: ApiResponse?) {
        hasActiveRequest = false
        if let response = response {
            DispatchQueue.main.async {
                self.dataStore.update(with: response)
            }
        }
    }

    private func updateData() {
        guard hasActiveRequest == false else { return }
        hasActiveRequest = true
        // We only use a post request if we have a location to post
        if let currentLocation = locationProvider.currentLocation {
            let body = SendLocationPostBody(device: deviceId, location: currentLocation)
            guard let bodyData = try? JSONEncoder().encode(body) else {
                hasActiveRequest = false
                defaultCompletion(for: nil)
                return
            }
            networkLayer.post(with: endpoint, decodable: ApiResponse.self, bodyData: bodyData, completion: defaultCompletion)
        } else {
            getData()
        }
    }

    public func getData() {
        networkLayer.get(with: endpoint, decodable: ApiResponse.self, completion: defaultCompletion)
    }

    public func send(messages: [SendChatMessage], completion: (([String: ChatMessage]?) -> Void)? = nil) {
        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask {
            self.networkLayer.cancelActiveRequestIfNeeded()
        }
        let body = SendMessagePostBody(device: deviceId, messages: messages)
        guard let bodyData = try? JSONEncoder().encode(body) else {
            return
        }
        networkLayer.post(with: endpoint, decodable: ApiResponse.self, bodyData: bodyData) { response in
            self.defaultCompletion(for: response)
            DispatchQueue.main.async {
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                completion?(response?.chatMessages)
            }
        }
    }
}
