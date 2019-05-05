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

        id = (deviceID + dateString).md5
    }

    public let id: String
}
