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
    var store: FriendsStorage!

    override func setUp() {
        super.setUp()

        store = FriendsStorageMock()

        var feature = Feature.friends
        feature.isActive = true

        sut = AppDataStore(friendsStorage: store)
        for friend in sut.friends {
            sut.remove(friend: friend)
        }
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testNotificationAfterStoringLocations() {
        let sut = AppDataStore(friendsStorage: store)
        let expectedObject = ApiResponse.Stubs.a
        let exp = expectation(forNotification: .positionOthersChanged, object: nil) { (notification) -> Bool in
            notification.object as AnyObject as! ApiResponse == expectedObject
        }
        exp.expectedFulfillmentCount = 1
        sut.update(with: .success(ApiResponse.Stubs.a))
        wait(for: [exp], timeout: 1)
    }

    func testNotificationAfterStoringChatMessage() {
        let sut = AppDataStore(friendsStorage: store)
        let expectedObject = ApiResponse.Stubs.b
        let exp = expectation(forNotification: .positionOthersChanged, object: nil) { (notification) -> Bool in
            notification.object as AnyObject as! ApiResponse == expectedObject
        }
        exp.expectedFulfillmentCount = 1
        sut.update(with: .success(ApiResponse.Stubs.b))
        wait(for: [exp], timeout: 1)
    }

    func testNoNoDoublicatedNotificationAfterStoringOldLocations() {
        let sut = AppDataStore(friendsStorage: store)
        let expectedObject = ApiResponse.Stubs.a
        var notificationCount = 0
        let exp = expectation(forNotification: .positionOthersChanged, object: nil) { (notification) -> Bool in
            notificationCount += 1
            return notification.object as AnyObject as! ApiResponse == expectedObject
        }
        let response: Result<ApiResponse, NetworkError> = .success(ApiResponse.Stubs.a)
        sut.update(with: response)
        sut.update(with: response)
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(notificationCount, 1)
    }

    func testNoNoDoublicatedNotificationAfterStoringOldMessages() {
        let sut = AppDataStore(friendsStorage: store)
        let expectedObject = ApiResponse.Stubs.b
        var notificationCount = 0
        let exp = expectation(forNotification: .positionOthersChanged, object: nil) { (notification) -> Bool in
            notificationCount += 1
            return notification.object as AnyObject as! ApiResponse == expectedObject
        }
        let response: Result<ApiResponse, NetworkError> = .success(ApiResponse.Stubs.b)
        sut.update(with: response)
        sut.update(with: response)
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(notificationCount, 1)
    }

    func testUpdateFriendLocation() {
//        let sut = AppDataStore(friendsStorage: userdefaults)

        XCTAssertEqual(sut.friends.count, 0)

        let friend = Friend(name: "Jan Ullrich", token: "1234")
        sut.add(friend: friend)

        XCTAssertEqual(sut.friends.count, 1)
        XCTAssertEqual(sut.friends[0], friend)
        XCTAssertFalse(sut.friends[0].isOnline)

        let token = IDStore.hash(id: "1234")
        let location = Location(longitude: 100, latitude: 100, timestamp: 100, name: "hello", color: "world")
        let response = [token: location]

        sut.updateFriendsLocations(locations: response)

        XCTAssertTrue(sut.friends[0].isOnline)
        XCTAssertEqual(sut.friends[0].location, location)
    }

    func testAddAndLoadFriends() {
        let sut = AppDataStore(friendsStorage: store)

        XCTAssertEqual(sut.friends.count, 0)

        let friend = Friend(name: "Jan Ullrich", token: UUID().uuidString)
        sut.add(friend: friend)

        XCTAssertEqual(sut.friends.count, 1)
        XCTAssertEqual(sut.friends[0], friend)

        let newStore = AppDataStore(friendsStorage: store)
        XCTAssertEqual(newStore.friends.count, 1)
        XCTAssertEqual(newStore.friends[0], friend)

        // clean up sut for future tests
        newStore.remove(friend: friend)
    }

    func testAddAndDeleteFriends() {
        let sut = AppDataStore(friendsStorage: store)

        XCTAssertEqual(sut.friends.count, 0)

        let friend = Friend(name: "Jan Ullrich", token: UUID().uuidString)
        let friend2 = Friend(name: "Jana Ullrich", token: UUID().uuidString)

        sut.add(friend: friend)
        sut.add(friend: friend2)

        XCTAssertEqual(sut.friends.count, 2)

        sut.remove(friend: friend2)
        XCTAssertEqual(sut.friends.count, 1)
        XCTAssertEqual(sut.friends[0], friend)

        let newStore = AppDataStore(friendsStorage: store)
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
}

private extension ApiResponse {
    enum Stubs {
        static let a = ApiResponse(
            locations: [
                "a": Location(
                    longitude: 100,
                    latitude: 100,
                    timestamp: 100,
                    name: "hello",
                    color: "world"
                )
            ],
            chatMessages: [:]
        )
        static let b = ApiResponse(
            locations: [:],
            chatMessages: ["b": ChatMessage(message: "Hello", timestamp: 1000)]
        )
    }
}
