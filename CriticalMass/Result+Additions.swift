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

    func isError() -> (Bool, Error?) {
        switch self {
        case .success:
            return (false, nil)
        case let .failure(error):
            return (true, error)
        }
    }
}
