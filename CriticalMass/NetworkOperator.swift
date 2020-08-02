//
//  NetworkOperator.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/17/19.
//

import Foundation

#if canImport(UIKit)
    import UIKit
#endif

public struct NetworkOperator: NetworkLayer {
    private let dataProvider: NetworkDataProvider
    private var networkIndicatorHelper: NetworkActivityIndicatorHelper?
    private static let validHttpResponseCodes = 200 ..< 299

    init(networkIndicatorHelper: NetworkActivityIndicatorHelper, dataProvider: NetworkDataProvider) {
        self.dataProvider = dataProvider
        self.networkIndicatorHelper = networkIndicatorHelper
    }

    public init(dataProvider: NetworkDataProvider) {
        self.dataProvider = dataProvider
    }

    public func get<T: APIRequestDefining>(request: T, completion: @escaping ResultCallback<T.ResponseDataType>) {
        guard let urlRequest = try? request.makeRequest() else {
            completion(Result.failure(NetworkError.unknownError(message: "Expected valid request")))
            return
        }
        dataTaskHandler(request: request, urlRequest: urlRequest, completion: completion)
    }

    public func post<T: APIRequestDefining>(request: T, bodyData: Data, completion: @escaping ResultCallback<T.ResponseDataType>) {
        guard var urlRequest = try? request.makeRequest() else {
            completion(Result.failure(NetworkError.unknownError(message: "Expected valid request")))
            return
        }
        urlRequest.httpBody = bodyData
        dataTaskHandler(request: request, urlRequest: urlRequest, completion: completion)
    }

    private func dataTaskHandler<T: APIRequestDefining>(request: T, urlRequest: URLRequest, completion: @escaping ResultCallback<T.ResponseDataType>) {
        #if canImport(UIKit)
            let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask {
                completion(.failure(NetworkError.unknownError(message: "Send message: backgroundTask failed")))
                self.cancelActiveRequestsIfNeeded()
            }
        #endif
        dataTask(with: urlRequest) { result in
            #if canImport(UIKit)
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            #endif
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
                          completion: @escaping ResultCallback<Data>)
    {
        networkIndicatorHelper?.didStartRequest()
        dataProvider.dataTask(with: request) { data, response, error in
            self.networkIndicatorHelper?.didEndRequest()
            guard (error as? URLError)?.code != URLError.notConnectedToInternet else {
                completion(.failure(NetworkError.offline))
                return
            }
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
    }

    public func cancelActiveRequestsIfNeeded() {
        dataProvider.invalidateAndCancel()
    }
}
