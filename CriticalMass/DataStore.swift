//
//  DataStore.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/15/19.
//

import Foundation

public protocol DataStore {
    func update(with response: ApiResponse)
}
