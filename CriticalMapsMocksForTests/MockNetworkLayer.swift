//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import Foundation

class MockNetworkLayer: NetworkLayer {
    var mockResponse: Decodable?
    var shouldReturnResponse = true
    var lastUsedPostBody: [String: Any]?
    var numberOfRequests: Int {
        numberOfGetCalled + numberOfPostCalled
    }

    var numberOfGetCalled = 0
    var numberOfPostCalled = 0

    func get<T: APIRequestDefining>(request _: T, completion: @escaping ResultCallback<T.ResponseDataType>) {
        numberOfGetCalled += 1
        if shouldReturnResponse {
            guard let response = mockResponse as? T.ResponseDataType else {
                completion(.failure(NetworkError.unknownError(message: "Should be ResponseDataType")))
                return
            }
            completion(.success(response))
        }
    }

    func post<T: APIRequestDefining>(request _: T, bodyData: Data, completion: @escaping ResultCallback<T.ResponseDataType>) {
        numberOfPostCalled += 1
        lastUsedPostBody = try! JSONSerialization.jsonObject(with: bodyData, options: []) as! [String: Any]
        if shouldReturnResponse {
            guard let response = mockResponse as? T.ResponseDataType else {
                completion(.failure(NetworkError.unknownError(message: "Should be ResponseDataType")))
                return
            }
            completion(.success(response))
        }
    }
}
