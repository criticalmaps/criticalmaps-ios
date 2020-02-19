//
//  UpdateDataOperation.swift
//  CriticalMaps
//
//  Created by Илья Глущук on 13/10/2019.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

final class UpdateDataOperation: AsyncOperation {
    private struct SendLocationAndChatMessagesPostBody: Encodable {
        let device: String
        let location: Location?
        var messages: [SendChatMessage]?
    }

    private let locationProvider: LocationProvider?
    private let idProvider: IDProvider
    private let networkLayer: NetworkLayer
    private var messages: [SendChatMessage]?

    var result: (Result<ApiResponse, NetworkError>)?

    init(locationProvider: LocationProvider?, idProvider: IDProvider, networkLayer: NetworkLayer, messages: [SendChatMessage]? = nil) {
        self.locationProvider = locationProvider
        self.idProvider = idProvider
        self.networkLayer = networkLayer
        self.messages = messages
        super.init()
    }

    override func main() {
        let body = SendLocationAndChatMessagesPostBody(
            device: idProvider.id,
            location: locationProvider?.currentLocation.map { Location($0) },
            messages: messages
        )
        guard let bodyData = try? body.encoded() else {
            result = .failure(.encodingError(body))
            state = .finished
            return
        }

        let request = PostLocationAndChatMessagesRequest()
        networkLayer.post(request: request, bodyData: bodyData) { [weak self] result in
            guard let self = self else { return }

            self.result = result
            self.state = .finished
        }
    }
}

extension UpdateDataOperation {
    func performWithoutQueue(completion: ((Result<ApiResponse, NetworkError>) -> Void)?) {
        completionBlock = {
            completion?(self.result!)
        }
        start()
    }
}
