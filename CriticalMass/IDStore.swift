//
//  IDStore.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import SwiftHash
import UIKit

public class IDStore: IDProvider {
    public init(currentDate: Date = Date()) {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let dateString = format.string(from: currentDate)

        // TODO: cleanup
        let realID = MD5(deviceID + dateString)
        let key = try! RSAKey(tag: RSAKey.keychainTag)
        id = realID
        signature = try! RSA.sign(realID.data(using: .utf8)!, privateKey: key.privateKey!).base64EncodedString()
    }

    public let signature: String
    public let id: String
}
