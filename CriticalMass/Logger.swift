//
//  Logger.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 6/1/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation
import os.log

class Logger {
    static func log(_ type: OSLogType, log: OSLog, _ message: StaticString) {
        if #available(iOS 12.0, macOS 10.14, *) {
            os_log(type, log: log, message)
        } else {
            print(message)
        }
    }
}
