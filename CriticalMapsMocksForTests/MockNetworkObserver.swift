//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import Foundation

class MockNetworkObserver: NetworkObserver {
    var status: NetworkStatus = .none
    var statusUpdateHandler: ((NetworkStatus) -> Void)?

    func update(with status: NetworkStatus) {
        self.status = status
        statusUpdateHandler?(status)
    }
}
