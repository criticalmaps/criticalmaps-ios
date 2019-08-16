//
//  ErrorHandler.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 16.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation
import os.log

struct ErrorHandler {
    static let `default` = ErrorHandler()

    let genericErrorMessage = "Sorry, something went wrong"

    func handleError(_ error: Error?) {
        if let errorDescription = error?.localizedDescription {
            presentToUser(message: errorDescription)
        } else {
            presentToUser(message: genericErrorMessage)
        }
    }

    private func presentToUser(message: String) {
        print(message)
    }
}
