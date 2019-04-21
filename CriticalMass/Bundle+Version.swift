//
//  Bundle+Version.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 28.03.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
