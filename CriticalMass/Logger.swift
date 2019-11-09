//
//  Logger.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 6/1/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let viewManagement = OSLog(subsystem: subsystem, category: "viewManagement")
}

class Logger {
    static func log(_ type: OSLogType, log: OSLog, _ message: StaticString) {
        if #available(iOS 12.0, *) {
            os_log(type, log: log, message)
        } else {
            print(message)
        }
    }

    static func log(_ type: OSLogType, log: OSLog, _ message: StaticString, parameter: String) {
        if #available(iOS 12.0, *) {
            let logMessage = "\(message): \(parameter)"
            os_log(type, log: log, "%@", logMessage)
        } else {
            print(message)
        }
    }
}
