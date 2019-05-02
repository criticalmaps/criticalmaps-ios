//
//  IDStore.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import Foundation

class IDStore: IDProvider {
    init() {
        id = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }

    private(set)
    var id: String
}
