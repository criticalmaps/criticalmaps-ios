//
//  NetworkOperator.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/17/19.
//

import Foundation

struct NetworkOperator: NetworkLayer {
    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session = URLSession(configuration: configuration)
    }

    func get<T>(with url: URL, decodable: T.Type, completion: @escaping (T?) -> Void) where T: Decodable {
        get(with: url, decodable: decodable, customDateFormatter: nil, completion: completion)
    }

    func get<T>(with url: URL, decodable: T.Type, customDateFormatter: DateFormatter?, completion: @escaping (T?) -> Void) where T: Decodable {
        let request = URLRequest(url: url)
        dataTask(with: request, decodable: decodable, customDateFormatter: customDateFormatter, completion: completion)
    }

    func post<T>(with url: URL, decodable: T.Type, bodyData: Data, completion: @escaping (T?) -> Void) where T: Decodable {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        dataTask(with: request, decodable: decodable, customDateFormatter: nil, completion: completion)
    }

    private func dataTask<T>(with request: URLRequest, decodable: T.Type, customDateFormatter: DateFormatter?, completion: @escaping (T?) -> Void) where T: Decodable {
        let task = session.dataTask(with: request) { data, _, _ in
            if let data = data {
                let decoder = JSONDecoder()
                if let customDateFormatter = customDateFormatter {
                    decoder.dateDecodingStrategy = .formatted(customDateFormatter)
                }
                let decodedResponse = try? decoder.decode(decodable, from: data)
                completion(decodedResponse)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

    func cancelActiveRequestsIfNeeded() {
        session.invalidateAndCancel()
    }
}
