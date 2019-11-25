//
//  UpdateDataOperation.swift
//  CriticalMaps
//
//  Created by Илья Глущук on 13/10/2019.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

final class UpdateDataOperation: AsyncOperation {
    private struct SendLocationPostBody: Encodable {
        let device: String
        let location: Location
    }

    private let locationProvider: LocationProvider
    private let idProvider: IDProvider
    private let networkLayer: NetworkLayer

    var result: (Result<ApiResponse, NetworkError>)?

    init(locationProvider: LocationProvider, idProvider: IDProvider, networkLayer: NetworkLayer) {
        self.locationProvider = locationProvider
        self.idProvider = idProvider
        self.networkLayer = networkLayer
        super.init()
    }

    override func main() {
        guard let currentLocation = locationProvider.currentLocation else {
            getLocationsAndChatMessages()
            return
        }

        let body = SendLocationPostBody(device: idProvider.id, location: currentLocation)
        guard let bodyData = try? body.encoded() else {
            state = .finished
            return
        }

        let request = PostLocationRequest()
        networkLayer.post(request: request, bodyData: bodyData) { [weak self] result in
            guard let self = self else { return }

            self.result = result
            self.state = .finished
        }
    }
}

private extension UpdateDataOperation {
    private func getLocationsAndChatMessages() {
        let request = GetLocationsAndChatMessagesRequest()
        networkLayer.get(request: request) { [weak self] result in
            guard let self = self else { return }

            self.result = result
            self.state = .finished
        }
    }
}
