//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import Foundation

class MockDataStore: DataStore {
    func remove(friend: Friend) {
        guard let index = friends.firstIndex(of: friend) else {
            return
        }
        friends.remove(at: index)
    }

    func add(friend: Friend) {
        friends.append(friend)
    }

    var friends: [Friend] = []
    var userName: String = "Jan Ullrich"

    var storedData: ApiResponse?
    func update(with response: ApiResponse) {
        storedData = response
    }
}
