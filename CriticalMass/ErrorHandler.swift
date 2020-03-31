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

public struct PrintErrorHandler: ErrorHandler {
    public init() {}

    public func handleError(_ error: Error?) {
        if let errorDescription = error?.localizedDescription {
            print(errorDescription)
        } else {
            print("Sorry, something went wrong")
        }
    }
}
