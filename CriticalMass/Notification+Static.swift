//
//  Notification+Static.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 19.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

extension Notification {
    static let themeDidChange = Notification.Name(rawValue: "themeDidChange")
    static let initialGpsDataReceived = Notification.Name(rawValue: "initialGpsDataReceived")
    static let observationModeChanged = Notification.Name(rawValue: "observationModeChanged")
    static let positionOthersChanged = Notification.Name(rawValue: "positionOthersChanged")
    static let chatMessagesReceived = Notification.Name(rawValue: "chatMessagesReceived")
}
