//
//  IDProvider.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import Foundation

protocol IDProvider {
    var id: String { get }
    var token: String { get }
    
    static func hash(id: String, currentDate: Date) -> String
}
