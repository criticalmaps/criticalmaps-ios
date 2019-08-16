//
//  NetworkLayer.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/17/19.
//

import Foundation

enum NetworkError: Error {
    case fetchFailed(Error?)
    case unknownError
    case parseError
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

typealias ResultCallback<Value> = Result<Value, NetworkError>

protocol NetworkLayer {
    func get<T: APIRequestDefining>(request: T, completion: @escaping (ResultCallback<T.ResponseDataType>) -> Void)
    func post<T: APIRequestDefining>(request: T, bodyData: Data, completion: @escaping (ResultCallback<T.ResponseDataType>) -> Void)
    func cancelActiveRequestsIfNeeded()
}
