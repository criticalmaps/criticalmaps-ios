//
//  IDStore.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import UIKit
import Crypto

public class IDStore: IDProvider {
    
    public let id: String
    public let token: String
    
    public init(currentDate: Date = Date()) {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString

        id = IDStore.hash(id: deviceID, currentDate: currentDate)
        token = deviceID
    }

    static public func hash(id: String, currentDate: Date = Date()) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let dateString = format.string(from: currentDate)
        
        return String(id + dateString).md5!
    }
}
