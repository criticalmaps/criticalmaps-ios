//
//  SimulationNetworkDataProvider.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 10.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class SimulationNetworkDataProvider: NetworkDataProvider {
    private var currentFrame = 0
    private var realNetworkDataProvider: NetworkDataProvider

    init(realNetworkDataProvider: NetworkDataProvider) {
        self.realNetworkDataProvider = realNetworkDataProvider
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = request.url,
              url.host == Constants.apiEndpoint,
              url.path.isEmpty
        else {
            // only the base API is supported
            // We are falling back to the real NetworkDataProvider
            realNetworkDataProvider.dataTask(with: request, completionHandler: completionHandler)
            return
        }

        if let asset = NSDataAsset(name: "snapshot_\(currentFrame)") {
            currentFrame += 1
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            completionHandler(asset.data, response, nil)
        } else {
            currentFrame = 0
            completionHandler(nil, nil, nil)
        }
    }

    func invalidateAndCancel() {
        realNetworkDataProvider.invalidateAndCancel()
    }
}
