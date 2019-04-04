//
//  RequestManagerTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 1/17/19.
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
    func setup(interval: TimeInterval, deviceId: String = "") -> (requestManager: RequestManager, locationProvider: MockLocationProvider, dataStore: MockDataStore, networkLayer: MockNetworkLayer) {
        let dataStore = MockDataStore()
        let locationProvider = MockLocationProvider()
        let networkLayer = MockNetworkLayer()
        return (RequestManager(dataStore: dataStore, locationProvider: locationProvider, networkLayer: networkLayer, interval: interval, deviceId: deviceId, url: Constants.apiEndpoint), locationProvider, dataStore, networkLayer)
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
        wait(for: [exp], timeout: 4)
    }

    func testRespectingRequestRepeatTime() {
        let numberOfExpectedRequests: TimeInterval = 2
        let interval: TimeInterval = 0.3
        let setup = self.setup(interval: interval)
        XCTAssertEqual(setup.networkLayer.numberOfRequests, 0)
        let exp = expectation(description: "Wait a second")
        wait(interval: interval * numberOfExpectedRequests) {
            XCTAssertEqual(Float(setup.networkLayer.numberOfRequests), Float(numberOfExpectedRequests), accuracy: 1)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 4)
    }

    func testStoredDataInDataStore() {
        let expectedStorage = ApiResponse(locations: ["a": Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")], chatMessages: ["b": ChatMessage(message: "Hello", timestamp: 1000)])
        let setup = self.setup(interval: 0.1)
        setup.networkLayer.mockResponse = expectedStorage
        XCTAssertNil(setup.dataStore.storedData)
        let exp = expectation(description: "Wait a second")
        wait(interval: 1) {
            XCTAssertNotNil(setup.dataStore.storedData)
            XCTAssertEqual(setup.dataStore.storedData!, expectedStorage)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 4)
    }

    func testPostLocation() {
        let deviceId = "123456789"
        let testSetup = setup(interval: 0.1, deviceId: deviceId)
        let testLocation = Location(longitude: 100, latitude: 101, timestamp: 0, name: nil, color: nil)
        testSetup.locationProvider.mockLocation = testLocation
        let expectedBody: [String: AnyHashable] = ["device": deviceId, "location": ["longitude": testLocation.longitude * 1_000_000, "latitude": testLocation.latitude * 1_000_000, "timestamp": 0]]
        XCTAssertNil(testSetup.dataStore.storedData)
        let exp = expectation(description: "Wait a second")
        wait(interval: 1) {
            XCTAssertEqual(testSetup.networkLayer.numberOfGetCalled, 0)
            XCTAssertGreaterThan(testSetup.networkLayer.numberOfPostCalled, 1)
            XCTAssertEqual(testSetup.networkLayer.lastUsedPostBody as! [String: AnyHashable], expectedBody)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 4)
    }

    func testSendMessage() {
        let deviceId = "123456789"
        let testSetup = setup(interval: 0.1, deviceId: deviceId)
        let testMessage = SendChatMessage(text: "Hello", timestamp: 100, identifier: UUID().uuidString)
        let expectedBody: [String: AnyHashable] = ["device": deviceId, "messages": [["text": testMessage.text, "timestamp": testMessage.timestamp, "identifier": testMessage.identifier]] as! [[String: AnyHashable]]]
        XCTAssertNil(testSetup.dataStore.storedData)
        testSetup.requestManager.send(messages: [testMessage])

        XCTAssertEqual(testSetup.networkLayer.numberOfGetCalled, 0)
        XCTAssertEqual(testSetup.networkLayer.numberOfPostCalled, 1)
        XCTAssertEqual(testSetup.networkLayer.lastUsedPostBody as! [String: AnyHashable], expectedBody)
    }
}
