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
        let key = try RSAKey(randomKey: "", isPermament: false)
        let publicKey = try key.publicKeyDataRepresentation()
        let friend = Friend(name: "Jan Ullrich", key: publicKey)
        let store = MockDataStore()
        store.add(friend: friend)

        let id = UUID().uuidString
        let signature = try RSA.sign(id.data(using: .utf8)!, privateKey: key.privateKey!)

        let friendsVerificationController = FriendsVerificationController(dataStore: store)
        let result = friendsVerificationController.isFriend(id: id, signature: signature.base64EncodedString())
        XCTAssertTrue(result)
    }

    func testVerifyNoFriend() throws {
        let key = try RSAKey(randomKey: "", isPermament: false)
        let publicKey = try key.publicKeyDataRepresentation()
        let friend = Friend(name: "Jan Ullrich", key: publicKey)
        let store = MockDataStore()
        store.add(friend: friend)

        let id = UUID().uuidString
        let otherKey = try RSAKey(randomKey: "", isPermament: false)
        let signature = try RSA.sign(id.data(using: .utf8)!, privateKey: otherKey.privateKey!)

        let friendsVerificationController = FriendsVerificationController(dataStore: store)
        let result = friendsVerificationController.isFriend(id: id, signature: signature.base64EncodedString())
        XCTAssertFalse(result)
    }
}
