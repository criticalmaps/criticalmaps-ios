//
//  FriendsVerificationController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import Foundation
import SwiftHash

public class FriendsVerificationController {
    private var dataStore: DataStore

    public init(dataStore: DataStore) {
        self.dataStore = dataStore
    }

    public func isFriend(id: String) -> Bool {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let dateString = format.string(from: Date())
        
        // TODO: cleanup
        // FIXME: move to SHA1
        
        for friend in dataStore.friends {
            if id == MD5(String(data: friend.token, encoding: .utf8)! + dateString) {
                return true
            }
        }
        return false
    }
}
