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
    func testVerifyFriend() throws {
        let token = UUID().uuidString

        let friend = Friend(name: "Jan Ullrich", token: token)
        let store = AppDataStore()
        store.add(friend: friend)

        let realToken = IDStore.hash(id: token)

        let friendsVerificationController = FriendsVerificationController(dataStore: store)
        let result = friendsVerificationController.isFriend(id: realToken)
        XCTAssertTrue(result)
    }

    func testVerifyNoFriend() throws {
        let token = UUID().uuidString
        let friend = Friend(name: "Jan Ullrich", token: token)
        let store = AppDataStore()
        store.add(friend: friend)

        let id = UUID().uuidString

        let friendsVerificationController = FriendsVerificationController(dataStore: store)
        let result = friendsVerificationController.isFriend(id: id)
        XCTAssertFalse(result)
    }
}
