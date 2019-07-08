//
//  AppDataStoreTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 1/17/19.
//

@testable import CriticalMaps
import XCTest

class AppDataStoreTests: XCTestCase {
    func testNotificationAfterStoringLocations() {
        let store = AppDataStore()
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
        let store = AppDataStore()
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
        let store = AppDataStore()
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
        let store = AppDataStore()
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

    func testAddAndLoadFriends() {
        let store = AppDataStore()

        XCTAssertEqual(store.friends.count, 0)

        let friend = Friend(name: "Jan Ullrich", key: try! RSAKey(randomKey: "Test", isPermament: false).publicKeyDataRepresentation())
        store.add(friend: friend)

        XCTAssertEqual(store.friends.count, 1)
        XCTAssertEqual(store.friends[0], friend)

        let newStore = AppDataStore()
        XCTAssertEqual(newStore.friends.count, 1)
        XCTAssertEqual(newStore.friends[0], friend)

        // clean up store for future tests
        newStore.remove(friend: friend)
    }

    func testAddAndDeleteFriends() {
        let store = AppDataStore()

        XCTAssertEqual(store.friends.count, 0)

        let friend = Friend(name: "Jan Ullrich", key: try! RSAKey(randomKey: "Test", isPermament: false).publicKeyDataRepresentation())
        let friend2 = Friend(name: "Jana Ullrich", key: try! RSAKey(randomKey: "Test", isPermament: false).publicKeyDataRepresentation())

        store.add(friend: friend)
        store.add(friend: friend2)

        XCTAssertEqual(store.friends.count, 2)

        store.remove(friend: friend2)
        XCTAssertEqual(store.friends.count, 1)
        XCTAssertEqual(store.friends[0], friend)

        let newStore = AppDataStore()
        XCTAssertEqual(newStore.friends.count, 1)
        XCTAssertEqual(newStore.friends[0], friend)

        store.remove(friend: friend)
        XCTAssertEqual(store.friends.count, 0)
    }
}
