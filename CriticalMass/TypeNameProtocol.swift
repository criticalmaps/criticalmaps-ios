//
//  TypeNameProtocol.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 08.05.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

public protocol TypeNameProtocol {
    static var typeName: String { get }
    var typeName: String { get }
}

public extension TypeNameProtocol {
    static var typeName: String {
        String(describing: self)
    }

    var typeName: String {
        type(of: self).typeName
    }
}

extension UIView: TypeNameProtocol {}
extension UIViewController: TypeNameProtocol {}
