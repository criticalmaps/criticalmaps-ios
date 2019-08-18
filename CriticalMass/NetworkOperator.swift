//
//  NetworkOperator.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/17/19.
//

import Foundation

struct NetworkOperator: NetworkLayer {
    private let session: URLSession
    private var networkIndicatorHelper: NetworkActivityIndicatorHelper

    init(networkIndicatorHelper: NetworkActivityIndicatorHelper) {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session = URLSession(configuration: configuration)
        self.networkIndicatorHelper = networkIndicatorHelper
    }

    func get<T: APIRequestDefining>(request: T, completion: @escaping ResultCallback<T.ResponseDataType>) {
        let urlRequest = request.makeRequest()
        dataTask(with: urlRequest) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(data):
                do {
                    let responseData = try request.parseResponse(data: data)
                    completion(.success(responseData))
                } catch {
                    completion(.failure(NetworkError.parseError))
                }
            }
        }
    }

    func post<T: APIRequestDefining>(request: T, bodyData: Data, completion: @escaping ResultCallback<T.ResponseDataType>) {
        var urlRequest = request.makeRequest()
        urlRequest.httpBody = bodyData
        dataTask(with: urlRequest) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(data):
                do {
                    let responseData = try request.parseResponse(data: data)
                    completion(.success(responseData))
                } catch {
                    completion(.failure(NetworkError.parseError))
                }
            }
        }
    }

    private func dataTask(with request: URLRequest,
                          completion: @escaping (Result<Data, NetworkError>) -> Void) {
        networkIndicatorHelper.didStartRequest()
        let task = session.dataTask(with: request) { data, response, error in
            self.networkIndicatorHelper.didEndRequest()
            if let error = error {
                completion(.failure(NetworkError.fetchFailed(error)))
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.unknownError))
            }
        }
        task.resume()
    }

    func cancelActiveRequestsIfNeeded() {
        session.invalidateAndCancel()
    }
}
