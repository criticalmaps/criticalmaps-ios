//
//  RequestManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import os.log
import UIKit

public class RequestManager {
    private struct SendLocationPostBody: Codable {
        var device: String
        var location: Location
    }

    private struct SendMessagePostBody: Codable {
        var device: String
        var messages: [SendChatMessage]
    }

    private var hasActiveRequest = false

    private var dataStore: DataStore
    private var locationProvider: LocationProvider
    private var networkLayer: NetworkLayer
    private var idProvider: IDProvider

    private var log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "RequestManager")

    init(dataStore: DataStore, locationProvider: LocationProvider, networkLayer: NetworkLayer, interval: TimeInterval = 12.0, idProvider: IDProvider) {
        self.idProvider = idProvider
        self.dataStore = dataStore
        self.locationProvider = locationProvider
        self.networkLayer = networkLayer
        configureTimer(with: interval)
    }

    private func configureTimer(with interval: TimeInterval) {
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerDidUpdate(timer:)), userInfo: nil, repeats: true)
    }

    @objc private func timerDidUpdate(timer _: Timer) {
        Logger.log(.info, log: log, "Timer did update")
        updateData()
    }

    private func defaultCompletion(for result: Result<ApiResponse, NetworkError>) {
        onMain { [weak self] in
            guard let self = self else { return }
            defer { self.hasActiveRequest = false }
            switch result {
            case let .success(response):
                self.dataStore.update(with: response)
                Logger.log(.info, log: self.log, "Successfully finished API update")
            case let .failure(error):
                ErrorHandler.default.handleError(error)
                Logger.log(.error, log: self.log, "API update failed")
            }
        }
    }

    private func updateData() {
        guard hasActiveRequest == false else {
            Logger.log(.info, log: log, "Don't attempt to request new data because because a request is still active")
            return
        }
        hasActiveRequest = true
        // We only use a post request if we have a location to post
        guard let currentLocation = locationProvider.currentLocation else {
            getData()
            return
        }
        let body = SendLocationPostBody(device: idProvider.id, location: currentLocation)
        guard let bodyData = try? body.encoded() else {
            hasActiveRequest = false
            return
        }
        let request = PostLocationRequest()
        networkLayer.post(request: request, bodyData: bodyData) { [weak self] result in
            guard let self = self else { return }
            self.defaultCompletion(for: result)
        }
    }

    public func getData() {
        let locationsAndMessagesRequest = GetLocationsAndChatMessagesRequest()
        networkLayer.get(request: locationsAndMessagesRequest) { [weak self] result in
            guard let self = self else { return }
            self.defaultCompletion(for: result)
        }
    }

    func send(messages: [SendChatMessage], completion: @escaping ResultCallback<[String: ChatMessage]>) {
        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask {
            completion(.failure(NetworkError.unknownError(message: "Send message: backgroundTask failed")))
            self.networkLayer.cancelActiveRequestsIfNeeded()
        }
        let body = SendMessagePostBody(device: idProvider.id, messages: messages)
        guard let bodyData = try? body.encoded() else {
            completion(.failure(NetworkError.encodingError(body)))
            return
        }
        let request = PostChatMessagesRequest()
        networkLayer.post(request: request, bodyData: bodyData) { [weak self] result in
            guard let self = self else { return }
            self.defaultCompletion(for: result)
            onMain {
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                switch result {
                case let .success(messages):
                    completion(.success(messages.chatMessages))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
