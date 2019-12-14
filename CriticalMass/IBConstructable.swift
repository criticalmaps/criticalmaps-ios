//
//  IBConstructable.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 19.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

protocol IBConstructable {
    static var nibName: String { get }
    static var bundle: Bundle { get }
    static var nib: UINib { get }
}

extension IBConstructable where Self: UIView {
    static var nibName: String {
        typeName
    }

    static var bundle: Bundle {
        Bundle(for: Self.self)
    }

    static var nib: UINib {
        UINib(nibName: nibName, bundle: bundle)
    }
}

extension IBConstructable where Self: UIViewController {
    static func fromNib() -> Self {
        self.init(nibName: nibName, bundle: bundle)
    }

    static var nibName: String {
        typeName
    }

    static var bundle: Bundle {
        Bundle(for: Self.self)
    }

    static var nib: UINib {
        UINib(nibName: nibName, bundle: bundle)
    }
}

extension IBConstructable where Self: UIView {
    static func fromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Missing view in \(nibName).xib")
        }
        return view
    }
}
