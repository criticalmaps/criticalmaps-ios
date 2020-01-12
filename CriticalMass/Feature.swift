
//
//  Feature.swift
//  CriticalMaps
//
//  Created by Felizia Bernutz on 08.12.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

private var currentState: [Feature: Bool] = [
    .friends: false,
    .events: false
]

enum Feature {
    case friends
    case events

    var isActive: Bool {
        set { currentState[self] = newValue }
        get { currentState[self] ?? false }
    }
}
