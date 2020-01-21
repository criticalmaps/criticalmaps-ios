//
//  MapOverlayErrorHandler.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 19.01.20.
//  Copyright © 2020 Pokus Labs. All rights reserved.
//

import Foundation

struct MapOverlayErrorHandler: ErrorHandler {
    private let presentInfoViewHandler: (MapInfoView.Configuration) -> Void

    init(presentInfoViewHandler: @escaping (MapInfoView.Configuration) -> Void) {
        self.presentInfoViewHandler = presentInfoViewHandler
    }

    func handleError(_ error: Error?) {
        let message = error?.localizedDescription ?? "Sorry, something went wrong"
        if Feature.errorHandler.isActive {
            presentInfoViewHandler(MapInfoView.Configuration(title: message, style: .alert))
        }
    }
}
