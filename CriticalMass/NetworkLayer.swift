//
//  NetworkLayer.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/17/19.
//

import Foundation

public enum NetworkError: Error {
    case fetchFailed(Error?)
    case unknownError(message: String)
    case decodingError(Error)
    case encodingError(Encodable)
    case noData(Error?)
    case invalidResponse
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .noData(error):
            return "Data is nil: Error:\(error)"
        case let .decodingError(error):
            return "Failed to decode data. Error: \(error)"
        case let .encodingError(error):
            return "Failed to encode body. Error: \(error)"
        case let .fetchFailed(error):
            return "Fetch Failed with error: \(error)"
        case .invalidResponse:
            return "Response is not vaild."
        case let .unknownError(message):
            return "UnknownError: \(message)"
        }
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public typealias ResultCallback<Value> = (Result<Value, NetworkError>) -> Void

public protocol NetworkLayer {
    func get<T: APIRequestDefining>(request: T, completion: @escaping ResultCallback<T.ResponseDataType>)
    func post<T: APIRequestDefining>(request: T, bodyData: Data, completion: @escaping ResultCallback<T.ResponseDataType>)
    func cancelActiveRequestsIfNeeded()
}
