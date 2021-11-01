//
//  CALayer+Shadow.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 17.12.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

extension CALayer {
    func setShadow(_ shadow: Shadow) {
        shadowColor = shadow.shadowColor
        shadowRadius = shadow.shadowRadius
        shadowOpacity = shadow.shadowOpacity
        shadowOffset = shadow.shadowOffset
    }
}

struct Shadow {
    let shadowColor: CGColor
    let shadowRadius: CGFloat
    let shadowOpacity: Float
    let shadowOffset: CGSize
}

extension Shadow {
    static var `default`: Self {
        Self(
            shadowColor: UIColor.black.cgColor,
            shadowRadius: 4,
            shadowOpacity: 0.2,
            shadowOffset: CGSize(width: 0, height: 2)
        )
    }
}
