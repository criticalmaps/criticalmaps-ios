//
//  MapController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import Foundation

class MapController {
    private var dataStore: DataStore

    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }

    public func isFriend(id: String, signature: String) -> Bool {
        // TODO: write Tests!

        guard let idData = id.data(using: .utf8),
            let signatureData = Data(base64Encoded: signature) else {
            return false
        }

        do {
            for friend in dataStore.friends {
                guard let key = try RSAKey(data: friend.key).publicKey else {
                    continue
                }
                // TODO: cache!
                let validSignature = try RSA.verify(idData, publicKey: key, signature: signatureData)
                if validSignature {
                    return true
                }
            }
        } catch {
            //
        }
//        return dataStore.friends.contains(string)
        return false
    }
}
