//
//  UITableView+Register.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 08.05.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

extension UITableViewCell {
    var reuseIdentifier: String? { return typeName }
    static var reuseIdentifier: String { return typeName }
}

extension UITableView {
    func register<T: UITableViewCell>(cellType _: T.Type) where T: IBConstructable {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewHeaderFooterView>(viewType _: T.Type) where T: IBConstructable {
        register(T.nib, forHeaderFooterViewReuseIdentifier: T.typeName)
    }

    func dequeueReusableCell<T: UITableViewCell>(ofType _: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Couldn't dequeue UITableViewCell with identifier: \"\(T.reuseIdentifier)\"")
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(ofType _: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.typeName) as? T else {
            fatalError("Couldn't dequeue UITableViewHeaderFooterView with identifier: \"\(T.typeName)\"")
        }
        return view
    }
}
