//
//  UseAutoLayout.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 06.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

@propertyWrapper
public struct UseAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet { setAutoLayout() }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        setAutoLayout()
    }

    private func setAutoLayout() {
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
