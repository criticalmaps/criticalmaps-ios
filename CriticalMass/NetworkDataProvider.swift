//
//  NetworkDataProvider.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 01.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

public protocol NetworkDataProvider {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    func invalidateAndCancel()
}

extension URLSession: NetworkDataProvider {
    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task: URLSessionDataTask = dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
}
