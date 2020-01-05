//
//  TwitterUser.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import Foundation

public struct TwitterUser: Codable, Equatable {
    public var name: String
    public var screen_name: String
    public var profile_image_url_https: String
}
