//
//  FriendsVerificationController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import Foundation

public class FriendsVerificationController {
    private var dataStore: DataStore
    private var friendsTokens = Set<String>()

    public init(dataStore: DataStore) {
        self.dataStore = dataStore
        updateFriendsTokens()
    }
    
    private func updateFriendsTokens() {
        friendsTokens.removeAll()

        for friend in dataStore.friends {
            let expectedId =  IDStore.hash(id: friend.token)
            friendsTokens.insert(expectedId)
        }
    }

    public func isFriend(id: String) -> Bool {
        return friendsTokens.contains(id)
    }
}
