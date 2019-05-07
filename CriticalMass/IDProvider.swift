//
//  IDProvider.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import Foundation

protocol IDProvider {
    var id: String { get }
    var signature: String { get }
}
