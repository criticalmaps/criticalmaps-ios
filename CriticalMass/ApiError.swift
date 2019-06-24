//
//  ApiError.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 24.06.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case couldFetchData
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .couldFetchData:
            return "Could load data from the server"
        }
    }
}
