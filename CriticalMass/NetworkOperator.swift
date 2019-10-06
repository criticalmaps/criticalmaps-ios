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
    private static let validHttpResponseCodes = 200 ..< 299

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
                } catch let decodingError {
                    completion(.failure(NetworkError.decodingError(decodingError)))
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
                } catch let decodingError {
                    completion(.failure(NetworkError.decodingError(decodingError)))
                }
            }
        }
    }

    private func dataTask(with request: URLRequest,
                          completion: @escaping ResultCallback<Data>) {
        networkIndicatorHelper.didStartRequest()
        let task = session.dataTask(with: request) { data, response, error in
            self.networkIndicatorHelper.didEndRequest()
            guard let data = data else {
                completion(.failure(NetworkError.noData(error)))
                return
            }
            guard
                let statusCode = (response as? HTTPURLResponse)?.statusCode,
                NetworkOperator.validHttpResponseCodes ~= statusCode
            else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }

    func cancelActiveRequestsIfNeeded() {
        session.invalidateAndCancel()
    }
}
