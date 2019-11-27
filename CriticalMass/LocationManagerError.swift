//
//  LocationManagerError.swift
//  CriticalMaps
//
//  Created by Илья Глущук on 27.11.2019.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

enum LocationManagerError: LocalizedError {
    case locationRetrieveError
}

extension LocationManagerError {
    var localizedDescription: String {
        switch self {
        case .locationRetrieveError:
            return "Failed to retreive location, empty array."
        }
    }
}
