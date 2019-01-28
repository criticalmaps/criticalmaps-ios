//
//  TwitterApiResponse.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import Foundation

struct TwitterApiResponse: Codable {
    var statuses: [Tweet]
}
