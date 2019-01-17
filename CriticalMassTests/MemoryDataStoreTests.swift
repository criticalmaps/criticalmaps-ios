//
//  MemoryDataStoreTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 1/17/19.
//

@testable import CriticalMaps
import XCTest

class MemoryDataStoreTests: XCTestCase {
    func testNotificationCalledAfterStoringData() {
        let store = MemoryDataStore()
        let expectedObject = ApiResponse(locations: ["a": Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")], chatMessages: ["b": ChatMessage(message: "Hello", timeStamp: 1000)])
        let notificationName = NSNotification.Name("positionOthersChanged")
        let exp = expectation(forNotification: notificationName, object: nil) { (notification) -> Bool in
            return notification.object as AnyObject as! ApiResponse == expectedObject
        }
        exp.expectedFulfillmentCount = 1
        store.update(with: ApiResponse(locations: ["a": Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")], chatMessages: ["b": ChatMessage(message: "Hello", timeStamp: 1000)]))
        wait(for: [exp], timeout: 1)
    }
}
