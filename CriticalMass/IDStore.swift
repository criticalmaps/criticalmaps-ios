//
//  IDStore.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import Foundation

public class IDStore: IDProvider {
    public init(currentDate: Date = Date()) {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let dateString = format.string(from: currentDate)

        // TODO: cleanup
        let realID = (deviceID + dateString).md5!
        let key = try! RSAKey(tag: RSAKey.keychainTag)
        let signature = try! RSA.sign(realID.data(using: .utf8)!, privateKey: key.privateKey!).base64EncodedString()
        id = realID
        self.signature = signature
    }

    public let signature: String
    public let id: String
}
