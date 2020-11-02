//
//  CALayer+Shadow.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 17.12.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

extension CALayer {
    func setupMapOverlayConfiguration(
        cornerRadius: CGFloat = 18
    ) {
        self.cornerRadius = cornerRadius
        shadowColor = UIColor.black.cgColor
        shadowRadius = 4
        shadowOpacity = 0.2
        shadowOffset = CGSize(width: 0, height: 2)
    }
}
