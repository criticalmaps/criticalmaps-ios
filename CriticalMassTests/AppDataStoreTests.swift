//
//  AppDataStoreTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 1/17/19.
//

@testable import CriticalMaps
import UIKit
import XCTest

class AppDataStoreTests: XCTestCase {
    var sut: AppDataStore!
    var userdefaults = UserDefaults(suiteName: "CriticalMaps-Tests")!

    override func setUp() {
        super.setUp()
        sut = AppDataStore(userDefaults: userdefaults)
        for friend in sut.friends {
            sut.remove(friend: friend)
        }
    }

    override func tearDown() {
        sut = nil
        userdefaults.removePersistentDomain(forName: "CriticalMaps-Tests")
        super.tearDown()
    }

    func testNotificationAfterStoringLocations() {
        let sut = AppDataStore()
        let expectedObject = ApiResponse(locations: ["a": Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")], chatMessages: [:])
        let notificationName = Notification.positionOthersChanged
        let exp = expectation(forNotification: notificationName, object: nil) { (notification) -> Bool in
            notification.object as AnyObject as! ApiResponse == expectedObject
        }
        exp.expectedFulfillmentCount = 1
        sut.update(with: ApiResponse(locations: ["a": Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")], chatMessages: [:]))
        wait(for: [exp], timeout: 1)
    }

    func testNotificationAfterStoringChatMessage() {
        let sut = AppDataStore()
        let expectedObject = ApiResponse(locations: [:], chatMessages: ["b": ChatMessage(message: "Hello", timestamp: 1000)])
        let notificationName = Notification.positionOthersChanged
        let exp = expectation(forNotification: notificationName, object: nil) { (notification) -> Bool in
            notification.object as AnyObject as! ApiResponse == expectedObject
        }
        exp.expectedFulfillmentCount = 1
        sut.update(with: ApiResponse(locations: [:], chatMessages: ["b": ChatMessage(message: "Hello", timestamp: 1000)]))
        wait(for: [exp], timeout: 1)
    }

    func testNoNoDoublicatedNotificationAfterStoringOldLocations() {
        let sut = AppDataStore()
        let expectedObject = ApiResponse(locations: ["a": Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")], chatMessages: [:])
        let notificationName = Notification.positionOthersChanged
        var notificationCount = 0
        let exp = expectation(forNotification: notificationName, object: nil) { (notification) -> Bool in
            notificationCount += 1
            return notification.object as AnyObject as! ApiResponse == expectedObject
        }
        let response = ApiResponse(locations: ["a": Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")], chatMessages: [:])
        sut.update(with: response)
        sut.update(with: response)
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(notificationCount, 1)
    }

    func testNoNoDoublicatedNotificationAfterStoringOldMessages() {
        let sut = AppDataStore()
        let expectedObject = ApiResponse(locations: [:], chatMessages: ["b": ChatMessage(message: "Hello", timestamp: 1000)])
        var notificationCount = 0
        let notificationName = Notification.positionOthersChanged
        let exp = expectation(forNotification: notificationName, object: nil) { (notification) -> Bool in
            notificationCount += 1
            return notification.object as AnyObject as! ApiResponse == expectedObject
        }
        let response = ApiResponse(locations: [:], chatMessages: ["b": ChatMessage(message: "Hello", timestamp: 1000)])
        sut.update(with: response)
        sut.update(with: response)
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(notificationCount, 1)
    }

    func testAddAndLoadFriends() {
        let sut = AppDataStore()

        XCTAssertEqual(sut.friends.count, 0)

        let friend = Friend(name: "Jan Ullrich", key: try! RSAKey(randomKey: "Test", isPermament: false).publicKeyDataRepresentation())
        sut.add(friend: friend)

        XCTAssertEqual(sut.friends.count, 1)
        XCTAssertEqual(sut.friends[0], friend)

        let newStore = AppDataStore()
        XCTAssertEqual(newStore.friends.count, 1)
        XCTAssertEqual(newStore.friends[0], friend)

        // clean up sut for future tests
        newStore.remove(friend: friend)
    }

    func testAddAndDeleteFriends() {
        let sut = AppDataStore()

        XCTAssertEqual(sut.friends.count, 0)

        let friend = Friend(name: "Jan Ullrich", key: try! RSAKey(randomKey: "Test", isPermament: false).publicKeyDataRepresentation())
        let friend2 = Friend(name: "Jana Ullrich", key: try! RSAKey(randomKey: "Test", isPermament: false).publicKeyDataRepresentation())

        sut.add(friend: friend)
        sut.add(friend: friend2)

        XCTAssertEqual(sut.friends.count, 2)

        sut.remove(friend: friend2)
        XCTAssertEqual(sut.friends.count, 1)
        XCTAssertEqual(sut.friends[0], friend)

        let newStore = AppDataStore()
        XCTAssertEqual(newStore.friends.count, 1)
        XCTAssertEqual(newStore.friends[0], friend)

        sut.remove(friend: friend)
        XCTAssertEqual(sut.friends.count, 0)
    }

    func testStoreDefaultUsername() {
        XCTAssertEqual(sut.userName, UIDevice.current.name)
    }

    func testStoreUsername() {
        let newName = "Jan Ullrich"
        XCTAssertNotEqual(sut.userName, newName)
        sut.userName = newName
        XCTAssertEqual(sut.userName, newName)
    }

    func testDontStoreEmptyUsername() {
        let newName = ""
        XCTAssertNotEqual(sut.userName, newName)
        sut.userName = newName
        XCTAssertNotEqual(sut.userName, newName)
    }
}
