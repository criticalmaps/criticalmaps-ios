//
//  DataStore.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/15/19.
//

import Foundation

protocol DataStore {
    func update(with response: ApiResponse)

    func addFriend(id: String)
    var friends: Set<String> { get }
}
