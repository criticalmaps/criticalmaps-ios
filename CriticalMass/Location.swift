//
//  Location.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

struct Location: Codable, Equatable {
    var longitude: Double
    var latitude: Double
    var timestamp: Float
    var name: String?
    var color: String?
}
