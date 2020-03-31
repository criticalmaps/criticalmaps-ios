//
// Created for CriticalMaps in 2020

import Foundation

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, sortOperator: ((T, T) -> Bool) = (<)) -> [Element] {
        sorted { (a, b) -> Bool in
            sortOperator(a[keyPath: keyPath], b[keyPath: keyPath])
        }
    }
}
