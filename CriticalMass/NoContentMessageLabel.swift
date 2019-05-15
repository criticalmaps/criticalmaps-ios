//
//  NoContentMessageLabel.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 12.05.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class NoContentMessageLabel: UILabel {
    @objc
    dynamic var messageTextColor: UIColor! {
        willSet { textColor = newValue }
    }
}
