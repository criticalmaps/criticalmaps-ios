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
            NotificationCenter.default.post(name: NSNotification.Name("positionOthersChanged"), object: lastKnownResponse)
        }
    }

    func update(with response: ApiResponse) {
        lastKnownResponse = response
    }
}
