//
//  RequestManagerTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 1/17/19.
//

@testable import CriticalMaps
import XCTest

class RequestManagerTests: XCTestCase {
    func setup(interval: TimeInterval, deviceId: String = "") -> (requestManager: RequestManager, locationProvider: MockLocationProvider, dataStore: MockDataStore, networkLayer: MockNetworkLayer, networkObserver: MockNetworkObserver) {
        let dataStore = MockDataStore()
        let locationProvider = MockLocationProvider()
        let networkLayer = MockNetworkLayer()
        let mockIDProvider = MockIDProvider()
        let networkObserver = MockNetworkObserver()
        mockIDProvider.mockID = deviceId
        return (RequestManager(dataStore: dataStore, locationProvider: locationProvider, networkLayer: networkLayer, interval: interval, idProvider: mockIDProvider, networkObserver: networkObserver), locationProvider, dataStore, networkLayer, networkObserver)
    }

    func testNoRequestForActiveRequests() {
        let setup = self.setup(interval: 0.1)
        setup.networkLayer.shouldReturnResponse = false
        XCTAssertEqual(setup.networkLayer.numberOfRequests, 0)

        expectToEventually(setup.networkLayer.numberOfRequests == 1)
    }

    func testRespectingRequestRepeatTime() {
        let numberOfExpectedRequests = 3
        let interval: TimeInterval = 0.3
        let setup = self.setup(interval: interval)
        XCTAssertEqual(setup.networkLayer.numberOfRequests, 0)

        expectToEventually(setup.networkLayer.numberOfRequests == numberOfExpectedRequests)
    }

    func testStoredDataInDataStore() {
        let expectedStorage = ApiResponse(
            locations: [
                "a": Location(
                    longitude: 100,
                    latitude: 100,
                    timestamp: 100,
                    name: "hello",
                    color: "world"
                )
            ],
            chatMessages: ["b": ChatMessage(message: "Hello", timestamp: 1000)]
        )
        let setup = self.setup(interval: 0.1)
        setup.networkLayer.mockResponse = expectedStorage
        XCTAssertNil(setup.dataStore.storedData)

        expectToEventually(setup.dataStore.storedData != nil)
        expectToEventually(setup.dataStore.storedData! == expectedStorage)
    }

    func testPostLocation() {
        let deviceId = "123456789"
        let signature = "Hello World"
        let testSetup = setup(interval: 0.1, deviceId: deviceId)
        let testLocation = Location(longitude: 100, latitude: 101, timestamp: 0, name: signature, color: nil)
        testSetup.locationProvider.mockLocation = testLocation
        let expectedBody: [String: AnyHashable] = [
            "device": deviceId,
            "location": [
                "longitude": testLocation.longitude * 1_000_000,
                "latitude": testLocation.latitude * 1_000_000,
                "timestamp": 0,
                "name": signature as AnyHashable
            ]
        ]
        XCTAssertNil(testSetup.dataStore.storedData)

        expectToEventually(testSetup.networkLayer.numberOfGetCalled == 0)
        expectToEventually(testSetup.networkLayer.numberOfPostCalled >= 1)
        expectToEventually(testSetup.networkLayer.lastUsedPostBody as? [String: AnyHashable] == expectedBody)
    }

    func testSendMessage() {
        let deviceId = "123456789"
        let testSetup = setup(interval: 0.1, deviceId: deviceId)
        let testMessage = SendChatMessage(text: "Hello", timestamp: 100, identifier: UUID().uuidString)
        let expectedBody: [String: AnyHashable] = [
            "device": deviceId,
            "messages": [
                [
                    "text": testMessage.text,
                    "timestamp": testMessage.timestamp,
                    "identifier": testMessage.identifier
                ]
            ] as! [[String: AnyHashable]]
        ]
        XCTAssertNil(testSetup.dataStore.storedData)
        testSetup.requestManager.send(messages: [testMessage]) { _ in }

        XCTAssertEqual(testSetup.networkLayer.numberOfGetCalled, 0)
        XCTAssertEqual(testSetup.networkLayer.numberOfPostCalled, 1)
        XCTAssertEqual(testSetup.networkLayer.lastUsedPostBody as! [String: AnyHashable], expectedBody)
    }

    // this test is flaky and should be made more tolerant
    // issue: https://github.com/criticalmaps/criticalmaps-ios/issues/266
    func test_NetworkSatisfiedStatusUpdate() {
        let setup = self.setup(interval: 4)
        setup.networkObserver.update(with: .satisfied)

        expectToEventually(setup.networkLayer.numberOfGetCalled == 0)
        expectToEventually(setup.networkLayer.numberOfPostCalled == 1)
    }

    func testNetworkNoneStatusUpdate() {
        let setup = self.setup(interval: 4)
        setup.networkObserver.update(with: .none)

        expectToEventually(setup.networkLayer.numberOfGetCalled == 0)
        expectToEventually(setup.networkLayer.numberOfPostCalled == 0)
    }

    func testRegainingNetworkAcccess() {
        let setup = self.setup(interval: 4)
        setup.networkObserver.update(with: .none)

        expectToEventually(setup.networkLayer.numberOfGetCalled == 0)
        expectToEventually(setup.networkLayer.numberOfPostCalled == 0)

        setup.networkObserver.update(with: .satisfied)

        expectToEventually(setup.networkLayer.numberOfGetCalled == 0)
        expectToEventually(setup.networkLayer.numberOfPostCalled == 1)
    }
}
