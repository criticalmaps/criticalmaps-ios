//
//  MapController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import Foundation

public class FriendsVerificationController {
    private var dataStore: DataStore

    public init(dataStore: DataStore) {
        self.dataStore = dataStore
    }

    public func isFriend(id: String, signature: String) -> Bool {
        guard let idData = id.data(using: .utf8),
            let signatureData = Data(base64Encoded: signature) else {
            return false
        }

        for friend in dataStore.friends {
            do {
                guard let key = try RSAKey(data: friend.key).publicKey else {
                    continue
                }
                // TODO: cache!
                let validSignature = try RSA.verify(idData, publicKey: key, signature: signatureData)
                if validSignature {
                    return true
                }
            } catch {
                // TODO: improve error handling.
            }
        }
        return false
    }
}
