//
//  MemoryDataStore.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/15/19.
//

import Foundation

class MemoryDataStore: DataStore {
    private var lastKnownResponse: ApiResponse? {
        didSet {
            if oldValue?.locations != lastKnownResponse?.locations {
                NotificationCenter.default.post(name: NSNotification.Name("positionOthersChanged"), object: lastKnownResponse)
            }
            if oldValue?.chatMessages != lastKnownResponse?.chatMessages {
                NotificationCenter.default.post(name: NSNotification.Name("chatMessagesReceived"), object: lastKnownResponse)
            }
        }
    }

    func update(with response: ApiResponse) {
        lastKnownResponse = response
    }

    func add(friend: Friend) {
        friends.insert(friend)
    }

    private(set)
    var friends: Set<Friend> = []
}
