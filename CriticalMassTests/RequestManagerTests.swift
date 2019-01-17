//
//  RequestManagerTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 1/17/19.
//

@testable import CriticalMaps
import XCTest

class MockLocationProvider: LocationProvider {
    var mockLocation: Location?

    var currentLocation: Location? {
        return mockLocation
    }
}

class MockNetworkLayer: NetworkLayer {
    var mockResponse: ApiResponse?
    var shouldReturnResponse = true
    var numberOfRequests = 0
    func get<T>(with _: URL, decodable _: T.Type, completion: @escaping (T?) -> Void) where T: Decodable {
        numberOfRequests += 1
        if shouldReturnResponse {
            completion(mockResponse as? T)
        }
    }

    func post<T>(with _: URL, decodable _: T.Type, body _: [String: Any], completion: @escaping (T?) -> Void) where T: Decodable {
        numberOfRequests += 1
        if shouldReturnResponse {
            completion(mockResponse as? T)
        }
    }
}

extension Location: Equatable {
    public static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude &&
            lhs.name == rhs.name &&
            lhs.timestamp == rhs.timestamp &&
            lhs.color == rhs.color
    }
}

extension ChatMessage: Equatable {
    public static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.message == rhs.message &&
            lhs.timeStamp == rhs.timeStamp
    }
}

extension ApiResponse: Equatable {
    public static func == (lhs: ApiResponse, rhs: ApiResponse) -> Bool {
        return lhs.chatMessages == rhs.chatMessages &&
            lhs.locations == rhs.locations
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
}

class RequestManagerTests: XCTestCase {
    func setup(interval: TimeInterval) -> (requestManager: RequestManager, locationProvider: MockLocationProvider, dataStore: MockDataStore, networkLayer: MockNetworkLayer) {
        let dataStore = MockDataStore()
        let locationProvider = MockLocationProvider()
        let networkLayer = MockNetworkLayer()
        return (RequestManager(dataStore: dataStore, locationProvider: locationProvider, networkLayer: networkLayer, interval: interval), locationProvider, dataStore, networkLayer)
    }

    func testNoRequestForActiveRequests() {
        let setup = self.setup(interval: 0.1)
        setup.networkLayer.shouldReturnResponse = false
        XCTAssertEqual(setup.networkLayer.numberOfRequests, 0)
        let exp = expectation(description: "Wait a second")
        wait(interval: 1) {
            XCTAssertEqual(setup.networkLayer.numberOfRequests, 1)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }

    func testRespectingRequestRepeatTime() {
        let numberOfExpectedRequests: TimeInterval = 15
        let interval: TimeInterval = 0.1
        let setup = self.setup(interval: 0.1)
        XCTAssertEqual(setup.networkLayer.numberOfRequests, 0)
        let exp = expectation(description: "Wait a second")
        wait(interval: interval * numberOfExpectedRequests) {
            XCTAssertEqual(Float(setup.networkLayer.numberOfRequests), Float(numberOfExpectedRequests), accuracy: 1)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }

    func testStoredDataInDataStore() {
        let expectedStorage = ApiResponse(locations: ["a": Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")], chatMessages: ["b": ChatMessage(message: "Hello", timeStamp: 1000)])
        let setup = self.setup(interval: 0.1)
        setup.networkLayer.mockResponse = expectedStorage
        XCTAssertNil(setup.dataStore.storedData)
        let exp = expectation(description: "Wait a second")
        wait(interval: 1) {
            XCTAssertNotNil(setup.dataStore.storedData)
            XCTAssertEqual(setup.dataStore.storedData!, expectedStorage)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }

    func testLocationProvider() {
        // TODO: not implemented yet
        XCTFail()
    }
}
