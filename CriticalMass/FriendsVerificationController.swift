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
            guard let tokenString = String(data: friend.token, encoding: .utf8) else {
                continue
            }
            let expectedId =  IDStore.hash(id: tokenString)
            friendsTokens.insert(expectedId)
        }
    }

    public func isFriend(id: String) -> Bool {
        return friendsTokens.contains(id)
    }
}
