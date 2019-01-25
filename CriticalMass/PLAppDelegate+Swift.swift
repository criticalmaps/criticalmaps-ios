//
//  PLAppDelegate+Swift.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/18/19.
//

import Foundation

extension PLAppDelegate {
    @objc
    public func getRequestManager() -> RequestManager {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        return RequestManager(dataStore: MemoryDataStore(), locationProvider: LocationManager(), networkLayer: NetworkOperator(), deviceId: deviceId.md5)
    }
}
