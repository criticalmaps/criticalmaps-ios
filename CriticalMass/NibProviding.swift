//
//  NibProviding.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 19.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

protocol NibProviding {
    static var typeName: String { get }
    static var nib: UINib { get }
}

extension NibProviding where Self: NSObject {
    static var typeName: String {
        return String(describing: Self.self)
    }
    static var nib: UINib {
        let nib = UINib(nibName: typeName, bundle: nil)
        return nib
    }
}
