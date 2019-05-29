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
    var mockResponse: Codable?
    var shouldReturnResponse = true
    var lastUsedPostBody: [String: Any]?
    var numberOfRequests: Int {
        return numberOfGetCalled + numberOfPostCalled
    }

    var numberOfGetCalled = 0
    var numberOfPostCalled = 0

    func get<T>(with _: URL, decodable _: T.Type, customDateFormatter _: DateFormatter?, completion: @escaping (T?) -> Void) where T: Decodable {
        numberOfGetCalled += 1
        if shouldReturnResponse {
            completion(mockResponse as? T)
        }
    }

    func get<T>(with url: URL, decodable: T.Type, completion: @escaping (T?) -> Void) where T: Decodable {
        get(with: url, decodable: decodable, customDateFormatter: nil, completion: completion)
    }

    func post<T>(with _: URL, decodable _: T.Type, bodyData: Data, completion: @escaping (T?) -> Void) where T: Decodable {
        numberOfPostCalled += 1
        lastUsedPostBody = try! JSONSerialization.jsonObject(with: bodyData, options: []) as! [String: Any]
        if shouldReturnResponse {
            completion(mockResponse as? T)
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
