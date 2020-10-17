//
// Created for CriticalMaps in 2020

import Foundation

extension Result {
    func get() throws -> Success {
        switch self {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    func isError() -> Bool {
        switch self {
        case .success:
            return false
        case .failure:
            return true
        }
    }
}
