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
        #if os(watchOS)
        let deviceID = UUID().uuidString
        #else
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        #endif

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let dateString = format.string(from: currentDate)

        id = MD5(deviceID + dateString)
    }

    public let id: String
}
