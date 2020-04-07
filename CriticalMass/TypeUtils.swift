//
// Created for CriticalMaps in 2020

import Foundation

func castTo<to: Any>(_ to: to.Type) -> (_ from: Any) -> (to?) {
    return { f in f as? to }
}

func canBeCastedTo<to: Any>(_ to: to.Type) -> (_ from: Any) -> (Bool) {
    return { f in f is to }
}
