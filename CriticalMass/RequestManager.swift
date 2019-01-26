//
//  RequestManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

// we need to inherit to NSObject because PLAppDelegate is currently in Objc and needs to hold a reference to this class
@objc(PLRequestManager)
public class RequestManager: NSObject {
    private struct SendLocationPostBody: Codable {
        var device: String
        var location: Location
    }

    private struct SendMessagePostBody: Codable {
        var device: String
        var messages: [ChatMessage]
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
        super.init()
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
                DispatchQueue.main.async {
                    self.dataStore.update(with: response)
                }
            }
        }

        // We only use a post request if we have a location to post
        if let currentLocation = locationProvider.currentLocation {
            let body = SendLocationPostBody(device: deviceId, location: currentLocation)
            guard let bodyData = try? JSONEncoder().encode(body) else {
                hasActiveRequest = false
                completion(nil)
                return
            }
            networkLayer.post(with: kBaseURL, decodable: ApiResponse.self, bodyData: bodyData, completion: completion)
        } else {
            networkLayer.get(with: kBaseURL, decodable: ApiResponse.self, completion: completion)
        }
    }

    public func send(messages: [ChatMessage], completion: (([String: ChatMessage]?) -> Void)? = nil) {
        guard hasActiveRequest == false else { return }
        hasActiveRequest = true
        let body = SendMessagePostBody(device: deviceId, messages: messages)
        guard let bodyData = try? JSONEncoder().encode(body) else {
            hasActiveRequest = false
            return
        }
        networkLayer.post(with: kBaseURL, decodable: ApiResponse.self, bodyData: bodyData) { response in
            self.hasActiveRequest = false
            if let response = response {
                self.dataStore.update(with: response)
                completion?(response.chatMessages)
            } else {
                completion?(nil)
            }
        }
    }
}
