//
//  ApiError.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 24.06.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case loadError
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .loadError:
            return "Could not load data from the server"
        }
    }
}
