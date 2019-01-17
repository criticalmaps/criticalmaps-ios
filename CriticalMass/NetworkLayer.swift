//
//  NetworkLayer.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/17/19.
//

import Foundation

protocol NetworkLayer {
    func get<T: Decodable>(with url: URL, decodable: T.Type, completion: @escaping (T?) -> Void)
}
