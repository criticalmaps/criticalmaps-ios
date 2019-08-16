//
//  TestHelper.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/12/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import XCTest

class MockLocationProvider: LocationProvider {
    static var accessPermission: LocationProviderPermission = .authorized

    var mockLocation: Location?

    var currentLocation: Location? {
        return mockLocation
    }
}

class MockNetworkLayer: NetworkLayer {
    var mockResponse: Decodable?
    var shouldReturnResponse = true
    var lastUsedPostBody: [String: Any]?
    var numberOfRequests: Int {
        return numberOfGetCalled + numberOfPostCalled
    }

    var numberOfGetCalled = 0
    var numberOfPostCalled = 0

    func get<T: APIRequestDefining>(request _: T, completion: (ResultCallback<T.ResponseDataType>) -> Void) {
        numberOfGetCalled += 1
        if shouldReturnResponse {
            guard let response = mockResponse as? T.ResponseDataType else {
                completion(.failure(NetworkError.unknownError))
                return
            }
            completion(.success(response))
        }
    }

    func post<T: APIRequestDefining>(request _: T, bodyData: Data, completion: (ResultCallback<T.ResponseDataType>) -> Void) {
        numberOfPostCalled += 1
        lastUsedPostBody = try! JSONSerialization.jsonObject(with: bodyData, options: []) as! [String: Any]
        if shouldReturnResponse {
            guard let response = mockResponse as? T.ResponseDataType else {
                completion(.failure(NetworkError.unknownError))
                return
            }
            completion(.success(response))
        }
    }

    func cancelActiveRequestsIfNeeded() {}
}

class MockIDProvider: IDProvider {
    var mockID: String?
    var id: String {
        if let mockID = mockID {
            return mockID
        } else {
            return UUID().uuidString
        }
    }
}

class MockDataStore: DataStore {
    var storedData: ApiResponse?
    func update(with response: ApiResponse) {
        storedData = response
    }
}

extension XCTestCase {
    func wait(interval: TimeInterval, completion: @escaping () -> Void) {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            completion()
        }
    }

    func execute(times: UInt, _ function: @autoclosure () -> Void) {
        (0 ..< times).forEach { _ in
            function()
        }
    }
}
