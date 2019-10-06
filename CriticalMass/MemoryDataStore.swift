//
//  MemoryDataStore.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/15/19.
//

import Foundation

class MemoryDataStore: DataStore {
    private(set) var lastKnownResponse: ApiResponse? {
        didSet {
            if oldValue?.locations != lastKnownResponse?.locations {
                NotificationCenter.default.post(name: Notification.positionOthersChanged, object: lastKnownResponse)
            }
            if oldValue?.chatMessages != lastKnownResponse?.chatMessages {
                NotificationCenter.default.post(name: Notification.chatMessagesReceived, object: lastKnownResponse)
            }
        }
    }

    func update(with response: ApiResponse) {
        lastKnownResponse = response
    }
}
