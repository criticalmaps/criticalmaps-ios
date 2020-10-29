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

    var error: Error? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }

    var failed: Bool {
        error != nil
    }
}
