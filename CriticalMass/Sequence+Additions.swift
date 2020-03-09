//
// Created for CriticalMaps in 2020

import Foundation

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, sortFunction: ((T, T) -> Bool) = (<)) -> [Element] {
        sorted { (a, b) -> Bool in
            sortFunction(a[keyPath: keyPath], b[keyPath: keyPath])
        }
    }
}
