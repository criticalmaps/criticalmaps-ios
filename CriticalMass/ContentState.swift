//
//  ContentState.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 30.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

enum ContentState<T> {
    case loading(LoadingViewController)
    case results(T)
    case error
}
