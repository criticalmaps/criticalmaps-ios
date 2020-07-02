//
// Created for CriticalMaps in 2020

import UIKit

protocol MessageConfigurable: AnyObject {
    associatedtype Model: Hashable
    func setup(for object: Model)
}

typealias IBConstructableMessageTableViewCell = UITableViewCell & IBConstructable & MessageConfigurable
