//
//  MemoryDataStoreTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 1/17/19.
//

@testable import CriticalMaps
import XCTest

class MemoryDataStoreTests: XCTestCase {
    func testNotificationAfterStoringLocations() {
        let store = MemoryDataStore()
        let expectedObject = ApiResponse(locations: ["a": Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")], chatMessages: [:])
        let notificationName = Notification.positionOthersChanged
        let exp = expectation(forNotification: notificationName, object: nil) { (notification) -> Bool in
            notification.object as AnyObject as! ApiResponse == expectedObject
        }
        exp.expectedFulfillmentCount = 1
        store.update(with: ApiResponse(locations: ["a": Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")], chatMessages: [:]))
        wait(for: [exp], timeout: 1)
    }

    func testNotificationAfterStoringChatMessage() {
        let store = MemoryDataStore()
        let expectedObject = ApiResponse(locations: [:], chatMessages: ["b": ChatMessage(message: "Hello", timestamp: 1000)])
        let notificationName = Notification.positionOthersChanged
        let exp = expectation(forNotification: notificationName, object: nil) { (notification) -> Bool in
            notification.object as AnyObject as! ApiResponse == expectedObject
        }
        exp.expectedFulfillmentCount = 1
        store.update(with: ApiResponse(locations: [:], chatMessages: ["b": ChatMessage(message: "Hello", timestamp: 1000)]))
        wait(for: [exp], timeout: 1)
    }

    func testNoNoDoublicatedNotificationAfterStoringOldLocations() {
        let store = MemoryDataStore()
        let expectedObject = ApiResponse(locations: ["a": Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")], chatMessages: [:])
        let notificationName = Notification.positionOthersChanged
        var notificationCount = 0
        let exp = expectation(forNotification: notificationName, object: nil) { (notification) -> Bool in
            notificationCount += 1
            return notification.object as AnyObject as! ApiResponse == expectedObject
        }
        let response = ApiResponse(locations: ["a": Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")], chatMessages: [:])
        store.update(with: response)
        store.update(with: response)
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(notificationCount, 1)
    }

    func testNoNoDoublicatedNotificationAfterStoringOldMessages() {
        let store = MemoryDataStore()
        let expectedObject = ApiResponse(locations: [:], chatMessages: ["b": ChatMessage(message: "Hello", timestamp: 1000)])
        var notificationCount = 0
        let notificationName = Notification.positionOthersChanged
        let exp = expectation(forNotification: notificationName, object: nil) { (notification) -> Bool in
            notificationCount += 1
            return notification.object as AnyObject as! ApiResponse == expectedObject
        }
        let response = ApiResponse(locations: [:], chatMessages: ["b": ChatMessage(message: "Hello", timestamp: 1000)])
        store.update(with: response)
        store.update(with: response)
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(notificationCount, 1)
    }
}
