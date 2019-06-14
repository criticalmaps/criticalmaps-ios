//
//  BlurryOverlayView.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 13.06.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class BlurryOverlayView: UIView, IBConstructable {
    @IBOutlet private var messageLabel: UILabel!

    public var message: String? {
        didSet {
            guard let text = message else {
                return
            }
            messageLabel.text = text
        }
    }
}
