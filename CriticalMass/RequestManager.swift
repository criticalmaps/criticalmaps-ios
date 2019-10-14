//
//  RequestManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import os.log
import UIKit
import Network

public class RequestManager {
    private struct SendMessagePostBody: Codable {
        var device: String
        var messages: [SendChatMessage]
    }

    private let endpoint: URL

    private var dataStore: DataStore
    private var locationProvider: LocationProvider
    private var networkLayer: NetworkLayer
    private var idProvider: IDProvider

    private var pathMonitorRef: AnyObject?

    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        return queue
    }()

    private var log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "RequestManager")

    @available(iOS 12.0, *)
    convenience init(dataStore: DataStore, locationProvider: LocationProvider, networkLayer: NetworkLayer, interval: TimeInterval = 6.0, idProvider: IDProvider, url: URL, pathMonitor: NWPathMonitor) {
        self.init(dataStore: dataStore, locationProvider: locationProvider, networkLayer: networkLayer, interval: interval, idProvider: idProvider, url: url)
        setup(pathMonitor: pathMonitor)
    }

    init(dataStore: DataStore, locationProvider: LocationProvider, networkLayer: NetworkLayer, interval: TimeInterval = 6.0, idProvider: IDProvider, url: URL) {
        endpoint = url
        self.idProvider = idProvider
        self.dataStore = dataStore
        self.locationProvider = locationProvider
        self.networkLayer = networkLayer

        addUpdateOperation(with: interval)
    }

    private func addUpdateOperation(with interval: TimeInterval) {
        let operation = UpdateDataOperation(locationProvider: locationProvider,
                                            idProvider: idProvider,
                                            networkLayer: networkLayer)
        let taskIdentifier = UIApplication.shared.beginBackgroundTask {
            self.networkLayer.cancelActiveRequestsIfNeeded()
            operation.cancel()
        }

        operation.completionBlock = { [weak self] in
            guard let self = self else { return }
            
            if let result = operation.result {
                self.defaultCompletion(for: result)
            }

            UIApplication.shared.endBackgroundTask(taskIdentifier)

            let waitOperation = WaitOperation(with: interval)
            self.operationQueue.addOperation(waitOperation)

            self.addUpdateOperation(with: interval)
        }

        operationQueue.addOperation(operation)
    }

    private func defaultCompletion(for result: Result<ApiResponse, NetworkError>) {
        onMain { [weak self] in
            guard let self = self else { return }
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

@available(iOS 12.0, *)
private extension RequestManager {
    func setup(pathMonitor: NWPathMonitor) {
        pathMonitor.pathUpdateHandler = { [weak self] path in
            self?.handlePathUpdate(path)
        }
        pathMonitor.start(queue: .main)
        
        pathMonitorRef = pathMonitor
    }

    func handlePathUpdate(_ path: NWPath) {
        if path.status == .satisfied {
            let operation = operationQueue.operations.first
            if operation is WaitOperation {
                operation?.cancel()
            }
        }
    }
}
