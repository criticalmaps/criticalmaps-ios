//
//  TwitterApiResponse.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import Foundation

public struct TwitterApiResponse: Codable {
    public var statuses: [Tweet]
}
