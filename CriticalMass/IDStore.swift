//
//  IDStore.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import SwiftHash
import UIKit

public class IDStore: IDProvider {
    
    public let id: String
    public let token: String
    
    public init(currentDate: Date = Date()) {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let dateString = format.string(from: currentDate)

        // TODO: cleanup
        // FIXME: move to SHA1
        let realID = MD5(deviceID + dateString)
        id = realID
        token = deviceID
    }
}
