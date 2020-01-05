        //
//  ErrorHandler.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 16.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

public protocol ErrorHandler {
    func handleError(_ error: Error?)
}
