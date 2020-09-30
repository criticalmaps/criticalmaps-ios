//
//  FriendsVerificationControllerTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 5/19/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import CriticalMaps
import XCTest

class FriendsVerificationControllerTests: XCTestCase {
    var sut: FriendsVerificationController!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testVerifyFriend() throws {
        let token = UUID().uuidString
        let friend = Friend(name: "Jan Ullrich", token: token)
        let store = AppDataStore(friendsStorage: FriendsStorageMock())
        store.add(friend: friend)

        let realToken = IDStore.hash(id: token)

        sut = FriendsVerificationController(dataStore: store)
        let result = sut.isFriend(id: realToken)
        XCTAssertTrue(result)
    }

    func testVerifyNoFriend() throws {
        let token = UUID().uuidString
        let friend = Friend(name: "Jan Ullrich", token: token)
        let store = AppDataStore(friendsStorage: FriendsStorageMock())
        store.add(friend: friend)
        sut = FriendsVerificationController(dataStore: store)

        let id = UUID().uuidString
        let result = sut.isFriend(id: id)
        XCTAssertFalse(result)
    }
}
