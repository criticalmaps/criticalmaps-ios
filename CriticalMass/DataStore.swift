//
//  DataStore.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/15/19.
//

import Foundation

public typealias ApiResponseResult = Result<ApiResponse, NetworkError>

public protocol DataStore {
    func update(with response: ApiResponseResult)

    func add(friend: Friend)
    func remove(friend: Friend)
    var friends: [Friend] { get }
    var userName: String { get set }
}
