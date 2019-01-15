//
//  Location.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

struct Location: Codable {
    var longitude: Float
    var latitude: Float
    var timestamp: Float
    var name: String?
    var color: String?
}
