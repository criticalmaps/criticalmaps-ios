//
//  ErrorStateModel.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 04.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

struct ErrorStateModel {
    let errorTitle: String
    let errorMessage: String
}

extension ErrorStateModel {
    static let fallback = ErrorStateModel(errorTitle: L10n.ErrorState.title,
                                          errorMessage: L10n.ErrorState.message)
}
