//
//  TwitterUser.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import Foundation

struct TwitterUser: Codable, Hashable {
    var name: String
    var screenName: String
    var profileImageUrl: String

    private enum CodingKeys: String, CodingKey {
        case name
        case screenName = "screen_name"
        case profileImageUrl = "profile_image_url_https"
    }
}
