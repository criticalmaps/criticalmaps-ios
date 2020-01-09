//
//  MockNetworkDataProvider.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 01.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import Foundation

struct MockNetworkDataProvider: NetworkDataProvider {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func dataTask(with _: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completionHandler(data, response, error)
    }

    func invalidateAndCancel() {}
}
