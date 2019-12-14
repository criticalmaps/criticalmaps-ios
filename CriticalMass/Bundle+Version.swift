//
//  Bundle+Version.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 28.03.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation
import UIKit

public extension Bundle {
    var versionNumber: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
