//
//  RequestManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import CriticalMapsFoundation
import Foundation
import os.log

@available(macOS 10.12, *)
public class RequestManager {
    private var dataStore: DataStore
    private var locationProvider: LocationProvider
    private var networkLayer: NetworkLayer
    private var idProvider: IDProvider
    private var networkObserver: NetworkObserver?

    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        return queue
    }()

    private var log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: "RequestManager")

    public init(dataStore: DataStore, locationProvider: LocationProvider, networkLayer: NetworkLayer, interval: TimeInterval = 12.0, idProvider: IDProvider, networkObserver: NetworkObserver?) {
        self.idProvider = idProvider
        self.dataStore = dataStore
        self.locationProvider = locationProvider
        self.networkLayer = networkLayer
        self.networkObserver = networkObserver

        setupNetworkObserver()
        addUpdateOperation(with: interval)
    }

    private func addUpdateOperation(with interval: TimeInterval) {
        let updateDataOperation = UpdateDataOperation(locationProvider: locationProvider,
                                                      idProvider: idProvider,
                                                      networkLayer: networkLayer)
        updateDataOperation.completionBlock = { [weak self] in
            guard let self = self else { return }

            if let result = updateDataOperation.result {
                self.defaultCompletion(for: result)
            }

            self.addUpdateOperation(with: interval)
        }

        let waitOperation = WaitOperation(with: interval)
        operationQueue.addOperation(waitOperation)

        let updateLocationOperation = UpdateLocationOperation(locationProvider: locationProvider)
        operationQueue.addOperation(updateLocationOperation)

        operationQueue.addOperation(updateDataOperation)
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
        UpdateDataOperation(locationProvider: nil, idProvider: idProvider, networkLayer: networkLayer)
            .performWithoutQueue { [weak self] result in
                guard let self = self else { return }
                self.defaultCompletion(for: result)
            }
    }

    func send(messages: [SendChatMessage], completion: @escaping ResultCallback<[String: ChatMessage]>) {
        UpdateDataOperation(locationProvider: nil, idProvider: idProvider, networkLayer: networkLayer, messages: messages)
            .performWithoutQueue { [weak self] result in
                guard let self = self else { return }

                self.defaultCompletion(for: result)
                onMain {
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

@available(macOS 10.12, *)
private extension RequestManager {
    func setupNetworkObserver() {
        networkObserver?.statusUpdateHandler = { [weak self] status in
            guard let self = self, status == .satisfied else {
                return
            }

            let operation = self.operationQueue.operations.first
            if operation is WaitOperation {
                operation?.cancel()
            }
        }
    }
}
